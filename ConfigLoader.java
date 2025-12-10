package com.example.api.config;

import lombok.Getter;
import org.yaml.snakeyaml.Yaml;
import org.yaml.snakeyaml.constructor.Constructor;

import java.io.InputStream;
import java.util.Map;

public class ConfigLoader {

    private static final String CONFIG_FILE = "/config.yml";

    @Getter
    private static ApiConfig config;

    static {
        load();
    }

    @SuppressWarnings("unchecked")
    private static void load() {
        try (InputStream inputStream = ConfigLoader.class.getResourceAsStream(CONFIG_FILE)) {
            if (inputStream == null) {
                throw new IllegalStateException("config.yml não encontrado em resources");
            }

            Yaml yaml = new Yaml();
            Map<String, Object> root = yaml.load(inputStream);

            String environment = (String) root.getOrDefault("environment", "dev");
            Map<String, Object> envMap = (Map<String, Object>) root.get(environment);

            if (envMap == null) {
                throw new IllegalStateException("Ambiente '" + environment + "' não encontrado no config.yml");
            }

            Yaml envYaml = new Yaml(new Constructor(ApiConfig.class));
            String envAsYaml = envYaml.dump(envMap);
            config = envYaml.load(envAsYaml);
        } catch (Exception e) {
            throw new RuntimeException("Erro ao carregar config.yml", e);
        }
    }
}