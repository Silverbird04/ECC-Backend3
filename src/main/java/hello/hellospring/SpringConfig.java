package hello.hellospring;

import hello.hellospring.repository.*;

import hello.hellospring.service.MemberService;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
/*
import javax.sql.DataSource;

@Configuration
public class SpringConfig {

    private final DataSource dataSource;

    public SpringConfig(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @Bean
    public MemberService memberService() {
        return new MemberService(memberRepository());
    }

    @Bean
    public MemberRepository memberRepository() {
//      return new MemoryMemberRepository();
//      return new JdbcMemberRepository(dataSource); // 스프링 통합 테스트
//      retrun new JdbcTemplateMemberRepository(dataSource); // 스프링 JdbcTemplate
        return new JpaMemberRepository(em); // JPA
    }
}
*/

// Spring JPA
@Configuration
public class SpringConfig {

    private final MemberRepository memberRepository;

    public SpringConfig(MemberRepository memberRepository) {
        this.memberRepository = memberRepository;
    }

    @Bean
    public MemberService memberService() {
        return new MemberService(memberRepository);
    }
}
