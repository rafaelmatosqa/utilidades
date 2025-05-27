import io.restassured.RestAssured;
import io.restassured.config.RestAssuredConfig;
import io.restassured.config.SSLConfig;
import static io.restassured.RestAssured.given;
import java.io.FileInputStream;
import java.security.KeyStore;

public class ClientCertificateAuthExample {

    public static void main(String[] args) {
        String pfxFilePath = "/caminho/para/seu/certificado.pfx"; // Altere para o caminho real do seu arquivo .pfx
        String pfxPassword = "sua_senha_do_pfx"; // Altere para a senha do seu arquivo .pfx

        try {
            // Carrega o KeyStore do arquivo .pfx
            KeyStore keyStore = KeyStore.getInstance("PKCS12");
            keyStore.load(new FileInputStream(pfxFilePath), pfxPassword.toCharArray());

            // Configura o RestAssured para usar o KeyStore
            RestAssured.config = RestAssuredConfig.config().sslConfig(
                new SSLConfig()
                    .keyStore(pfxFilePath, pfxPassword) // Carrega o keystore do caminho do arquivo
                    .keystoreType("PKCS12") // Especifica o tipo de keystore
                    // Se você tiver um truststore separado (para confiar em certificados de servidor),
                    // você pode configurá-lo aqui também. Ex:
                    // .trustStore("/caminho/para/seu/truststore.jks", "senha_truststore")
                    // .trustStoreType("JKS")
                    // Caso o certificado do servidor seja auto-assinado ou não confiável pela JVM padrão,
                    // você pode precisar relaxar a validação do hostname ou a validação HTTPS
                    // .relaxedHTTPSValidation() // Use com cautela em ambientes de produção
            );

            // Exemplo de requisição
            given()
                .header("Content-Type", "application/json")
                .body("{ \"key\": \"value\" }") // Exemplo de corpo da requisição
            .when()
                .post("https://seu-endpoint-seguro.com/api/recurso") // Altere para seu endpoint
            .then()
                .statusCode(200) // Verifique o código de status esperado
                .log().all(); // Loga toda a resposta para depuração

        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Erro ao realizar a requisição com certificado: " + e.getMessage());
        }
    }
}
