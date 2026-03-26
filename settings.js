module.exports = {
    flowFile: 'flows.json',
    credentialsFile: 'flows_cred.json',

    flowFilePretty: true,

    uiPort: process.env.PORT || 1880,

    diagnostics: {
        enabled: true,
        ui: true,
    },

    runtimeState: {
        enabled: false,
        ui: false,
    },

    logging: {
        console: {
            level: 'info',
            metrics: false,
            audit: false,
        },
    },

    exportGlobalContextKeys: false,

    externalModules: {},

    editorTheme: {
        projects: {
            enabled: true,
        },
        palette: {
            editable: true,
        },
    },

    functionExternalModules: true,
    functionTimeout: 0,

    debugMaxLength: 1000,

    mqttReconnectTime: 15000,
    serialReconnectTime: 15000,
};
