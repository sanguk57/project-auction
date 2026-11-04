package com.myauct.web.support;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.Connection;
import java.sql.SQLException;

import javax.sql.DataSource;

import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.support.EncodedResource;
import org.springframework.jdbc.datasource.init.ScriptUtils;

/**
 * 테스트용 H2 메모리 DB 를 sql/schema.sql + sql/sample-data.sql 로 처음 상태로 되돌린다.
 * (실제 MySQL 은 쓰지 않는다 → pom.xml 의 surefire 설정이 테스트 설정 파일을 지정)
 */
public final class TestDb {

	private TestDb() {
	}

	public static void reset(DataSource dataSource) {
		try (Connection conn = dataSource.getConnection()) {
			run(conn, "sql/schema.sql");
			run(conn, "sql/sample-data.sql");
		} catch (SQLException | IOException e) {
			throw new IllegalStateException("테스트 DB 초기화 실패", e);
		}
	}

	private static void run(Connection conn, String file) throws IOException {
		String sql = Files.readString(Path.of(file), StandardCharsets.UTF_8);
		sql = sql.replaceAll("(?im)^\\s*USE\\s+\\w+\\s*;", ""); // H2 에는 USE 가 없음
		ScriptUtils.executeSqlScript(conn,
				new EncodedResource(new ByteArrayResource(sql.getBytes(StandardCharsets.UTF_8)), StandardCharsets.UTF_8));
	}
}
