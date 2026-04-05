module.exports = {
    flowFile: 'flows.json',
    credentialsFile: 'flows_cred.json',
    credentialSecret: process.env.NODE_RED_CREDENTIAL_SECRET,

    flowFilePretty: true,

    uiPort: process.env.PORT || 1880,

    adminAuth: {
        type: 'credentials',
        users: [{
            username: process.env.NODE_RED_ADMIN_USER || 'admin',
            password: process.env.NODE_RED_ADMIN_PASSWORD_HASH,
            permissions: '*',
        }],
    },

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
    functionTimeout: 30,

    debugMaxLength: 1000,

    mqttReconnectTime: 15000,
    serialReconnectTime: 15000,
};
