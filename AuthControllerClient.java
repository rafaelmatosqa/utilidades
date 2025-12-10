package com.example.api.client;

import com.example.api.config.ApiConfig;
import com.example.api.config.ConfigLoader;
import com.example.api.core.SpecificationFactory;
import io.restassured.RestAssured;
import io.restassured.response.ValidatableResponse;

public class AuthControllerClient extends BaseApiClient {

    private final ApiConfig apiConfig = ConfigLoader.getConfig();

    /**
     * Exemplo de login com Basic Auth
     * Ajuste o path conforme seu gateway / Bacen wrapper.
     */
    public ValidatableResponse loginWithBasic() {
        ApiConfig.BasicAuth basicAuth = apiConfig.getBasicAuth();

        return RestAssured.given()
                .spec(SpecificationFactory.requestSpec())
                .auth()
                .preemptive()
                .basic(basicAuth.getUsername(), basicAuth.getPassword())
                .when()
                .post("/auth/basic-login")
                .then()
                .spec(SpecificationFactory.responseSpec());
    }

    /**
     * Exemplo de chamada com Bearer Token
     */
    public ValidatableResponse validarToken() {
        String token = apiConfig.getBearerToken();

        return RestAssured.given()
                .spec(SpecificationFactory.requestSpec())
                .header("Authorization", "Bearer " + token)
                .when()
                .get("/auth/validate")
                .then()
                .spec(SpecificationFactory.responseSpec());
    }
}