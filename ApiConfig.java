package com.example.api.config;

import lombok.Data;

@Data
public class ApiConfig {

    private String baseUri;
    private String xCert;

    private String keystorePath;
    private String keystorePassword;

    private String truststorePath;
    private String truststorePassword;

    private BasicAuth basicAuth;
    private String bearerToken;

    @Data
    public static class BasicAuth {
        private String username;
        private String password;
    }
}