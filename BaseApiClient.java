package com.example.api.client;

import com.example.api.core.SpecificationFactory;
import io.restassured.RestAssured;
import io.restassured.response.ValidatableResponse;
import io.restassured.specification.RequestSpecification;

import java.util.Map;

public class BaseApiClient {

    protected RequestSpecification baseRequest() {
        return RestAssured
                .given()
                .spec(SpecificationFactory.requestSpec());
    }

    protected RequestSpecification prepareRequest(Map<String, ?> pathParams,
                                                  Map<String, ?> queryParams) {

        RequestSpecification request = baseRequest();

        if (pathParams != null && !pathParams.isEmpty()) {
            request.pathParams(pathParams);
        }
        if (queryParams != null && !queryParams.isEmpty()) {
            request.queryParams(queryParams);
        }

        return request;
    }

    // GET
    protected ValidatableResponse doGet(String path,
                                        Map<String, ?> pathParams,
                                        Map<String, ?> queryParams) {

        return prepareRequest(pathParams, queryParams)
                .when()
                .get(path)
                .then()
                .spec(SpecificationFactory.responseSpec());
    }

    // POST
    protected <T> ValidatableResponse doPost(String path,
                                             T body,
                                             Map<String, ?> pathParams,
                                             Map<String, ?> queryParams) {

        return prepareRequest(pathParams, queryParams)
                .body(body)
                .when()
                .post(path)
                .then()
                .spec(SpecificationFactory.responseSpec());
    }

    // PUT
    protected <T> ValidatableResponse doPut(String path,
                                            T body,
                                            Map<String, ?> pathParams,
                                            Map<String, ?> queryParams) {

        return prepareRequest(pathParams, queryParams)
                .body(body)
                .when()
                .put(path)
                .then()
                .spec(SpecificationFactory.responseSpec());
    }

    // PATCH
    protected <T> ValidatableResponse doPatch(String path,
                                              T body,
                                              Map<String, ?> pathParams,
                                              Map<String, ?> queryParams) {

        return prepareRequest(pathParams, queryParams)
                .body(body)
                .when()
                .patch(path)
                .then()
                .spec(SpecificationFactory.responseSpec());
    }

    // DELETE
    protected ValidatableResponse doDelete(String path,
                                           Map<String, ?> pathParams,
                                           Map<String, ?> queryParams) {

        return prepareRequest(pathParams, queryParams)
                .when()
                .delete(path)
                .then()
                .spec(SpecificationFactory.responseSpec());
    }
}