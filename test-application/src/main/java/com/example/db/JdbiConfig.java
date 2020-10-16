package com.example.db;

import javax.sql.DataSource;

import org.apache.commons.dbcp2.ConnectionFactory;
import org.apache.commons.dbcp2.DriverManagerConnectionFactory;
import org.apache.commons.dbcp2.PoolableConnection;
import org.apache.commons.dbcp2.PoolableConnectionFactory;
import org.apache.commons.dbcp2.PoolingDataSource;
import org.apache.commons.pool2.ObjectPool;
import org.apache.commons.pool2.impl.GenericObjectPool;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.sqlobject.SqlObjectPlugin;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class JdbiConfig {

    @Bean
    DataSource dataSource(
            @Value("${ds.host}") String serverName, @Value("${ds.dbname}") String databaseName,
            @Value("${ds.user}") String user, @Value("${ds.password}") String password,
            @Value("${ds.port}") int portNumber
    ) {
        return setupDataSource(String.format("jdbc:postgresql://%s:%d/%s", serverName, portNumber, databaseName), user, password);
    }

    @Bean
    Jdbi jdbi(final DataSource dataSource) {
        Jdbi jdbi = Jdbi.create(dataSource);
        jdbi.installPlugin(new SqlObjectPlugin());
        return jdbi;
    }

    private static DataSource setupDataSource(final String connectURI, final String user, final String password) {
        final ConnectionFactory connectionFactory = new DriverManagerConnectionFactory(connectURI, user, password);
        final PoolableConnectionFactory poolableConnectionFactory = new PoolableConnectionFactory(connectionFactory, null);
        final ObjectPool<PoolableConnection> connectionObjectPool = new GenericObjectPool<>(poolableConnectionFactory);
        poolableConnectionFactory.setPool(connectionObjectPool);
        return new PoolingDataSource<>(connectionObjectPool);
    }
}
