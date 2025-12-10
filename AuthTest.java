package com.example.api.tests;

import com.example.api.client.AuthControllerClient;
import com.example.api.core.SpecificationFactory;
import io.restassured.RestAssured;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

public class AuthTests {

    private AuthControllerClient authClient;

    @BeforeClass
    public void setUp() {
        RestAssured.requestSpecification = SpecificationFactory.requestSpec();
        RestAssured.responseSpecification = SpecificationFactory.responseSpec();

        authClient = new AuthControllerClient();
    }

    @Test
    public void testLoginComBasic() {
        authClient.loginWithBasic()
                .statusCode(200);
    }

    @Test
    public void testChamadaComBearer() {
        authClient.validarToken()
                .statusCode(200);
    }
}