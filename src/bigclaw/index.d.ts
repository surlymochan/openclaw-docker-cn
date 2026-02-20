declare const compositeSearchPlugin: {
    id: string;
    name: string;
    description: string;
    kind: string;
    configSchema: any;
    register(api: any): void;
};
export default compositeSearchPlugin;
