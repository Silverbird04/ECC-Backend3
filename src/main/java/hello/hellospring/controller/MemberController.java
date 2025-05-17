package hello.hellospring.controller;

// 회원 컨트롤러에 의존관계 추가
import hello.hellospring.service.MemberService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MemberController {

    private final MemberService memberService;

    @Autowired
    public MemberController(MemberService memberService){
        this.memberService = memberService;
    }

    @GetMapping(value = "/members/new") // home.html의 "/members/new"
    public String createForm() {
        return "members/createMemberForm";
    }

    // 회원 웹 기능 - 등록
    @PostMapping(value = "/members/new")
    public String create(MemberForm form) {
        Member member = new Member();
        member.setName(form.getName());
        /* test
        System.out.println("member = " + member.getName());
        웹사이트에서 이름 등록
        'member = 이름' 출력
        */

        memberService.join(member);

        return "redirect:/";
    }

    @GetMapping(value = "/members")
    public String list(Model model) {
        List<Member> members = memberService.findMembers();
        model.addAttribute(attributeName:"members", members);
        return "members/memberList";
    }
}