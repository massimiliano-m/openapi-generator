import { HttpLibrary } from "./http/http";
import { Middleware, PromiseMiddleware, PromiseMiddlewareWrapper } from "./middleware";
import { IsomorphicFetchHttpLibrary as DefaultHttpLibrary } from "./http/isomorphic-fetch";
import { BaseServerConfiguration, server1 } from "./servers";
import { configureAuthMethods, AuthMethods, AuthMethodsConfiguration } from "./auth/auth";

export interface Configuration<M = Middleware> {
    readonly baseServer: BaseServerConfiguration;
    readonly httpApi: HttpLibrary;
    readonly middleware: M[];
    readonly authMethods: AuthMethods;
}

// Additional option specific to middleware merge strategy
export interface MiddlewareMergeOptions {
    // default is `"replace"` for backwards compatibility
    middlewareMergeStrategy?: "replace" | "append" | "prepend";
}

// Unify configuration options using Partial plus extra merge strategy
export type ConfigurationOptions<M = Middleware> = Partial<Configuration<M>> & MiddlewareMergeOptions;

//  aliases for convenience
export type StandardConfigurationOptions = ConfigurationOptions<Middleware>;
export type PromiseConfigurationOptions = ConfigurationOptions<PromiseMiddleware>;

/**
 * Interface with which a configuration object can be configured.
 */
export interface ConfigurationParameters {
    /**
     * Default server to use - a list of available servers (according to the
     * OpenAPI yaml definition) is included in the `servers` const in `./servers`. You can also
     * create your own server with the `ServerConfiguration` class from the same
     * file.
     */
    baseServer?: BaseServerConfiguration;
    /**
     * HTTP library to use e.g. IsomorphicFetch. This can usually be skipped as
     * all generators come with a default library.
     * If available, additional libraries can be imported from `./http/*`
     */
    httpApi?: HttpLibrary;

    /**
     * The middlewares which will be applied to requests and responses. You can
     * add any number of middleware components to modify requests before they
     * are sent or before they are deserialized by implementing the `Middleware`
     * interface defined in `./middleware`
     */
    middleware?: Middleware[];
    /**
     * Configures middleware functions that return promises instead of
     * Observables (which are used by `middleware`). Otherwise allows for the
     * same functionality as `middleware`, i.e., modifying requests before they
     * are sent and before they are deserialized.
     */
    promiseMiddleware?: PromiseMiddleware[];
    /**
     * Configuration for the available authentication methods (e.g., api keys)
     * according to the OpenAPI yaml definition. For the definition, please refer to
     * `./auth/auth`
     */
    authMethods?: AuthMethodsConfiguration
}

/**
 * Provide your `ConfigurationParameters` to this function to get a `Configuration`
 * object that can be used to configure your APIs (in the constructor or
 * for each request individually).
 *
 * If a property is not included in conf, a default is used:
 *    - baseServer: server1
 *    - httpApi: IsomorphicFetchHttpLibrary
 *    - middleware: []
 *    - promiseMiddleware: []
 *    - authMethods: {}
 *
 * @param conf partial configuration
 */
export function createConfiguration(conf: ConfigurationParameters = {}): Configuration {
    const configuration: Configuration = {
        baseServer: conf.baseServer !== undefined ? conf.baseServer : server1,
        httpApi: conf.httpApi || new DefaultHttpLibrary(),
        middleware: conf.middleware || [],
        authMethods: configureAuthMethods(conf.authMethods)
    };
    if (conf.promiseMiddleware) {
        conf.promiseMiddleware.forEach(
            m => configuration.middleware.push(new PromiseMiddlewareWrapper(m))
        );
    }
    return configuration;
}

/**
 * Merge configuration options into a configuration.
 */
export function mergeConfiguration(conf: Configuration, options?: Configuration): Configuration {
    return options || conf;
}

/**
 * Convert Promise-based configuration options to Observable-based configuration options.
 */
export function wrapOptions(options?: PromiseConfigurationOptions): StandardConfigurationOptions | undefined {
    if (options) {
        return {
            baseServer: options.baseServer,
            httpApi: options.httpApi,
            middleware: options.middleware?.map(
              m => new PromiseMiddlewareWrapper(m)
            ),
            middlewareMergeStrategy: options.middlewareMergeStrategy,
            authMethods: options.authMethods,
        };
    }
    return;
}
