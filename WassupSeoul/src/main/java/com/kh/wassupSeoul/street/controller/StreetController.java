package com.kh.wassupSeoul.street.controller;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartRequest;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.kh.wassupSeoul.common.FileRename;
import com.kh.wassupSeoul.friends.model.vo.Relationship;
import com.kh.wassupSeoul.hobby.model.vo.Hobby;
import com.kh.wassupSeoul.member.model.vo.Member;
import com.kh.wassupSeoul.member.model.vo.ProfileStreet;
import com.kh.wassupSeoul.square.model.vo.Alarm;
import com.kh.wassupSeoul.street.model.service.StreetService;
import com.kh.wassupSeoul.street.model.vo.Board;
import com.kh.wassupSeoul.street.model.vo.Keyword;
import com.kh.wassupSeoul.street.model.vo.Reply;
import com.kh.wassupSeoul.street.model.vo.Street;

@SessionAttributes({ "loginMember", "msg", "streetNo", "myStreet" })
@Controller
@RequestMapping("/street/*")
public class StreetController {

	@Autowired
	private StreetService streetService;

	// -------------------------------------------- 중하  ---------------------------------------------
	
	// 타임라인 이동
	@RequestMapping(value = "streetMain", method = RequestMethod.GET)
	public String timeLine(Integer streetNo, Model model, RedirectAttributes rdAttr, HttpServletRequest request) {

		Member loginMember = (Member) model.getAttribute("loginMember");

		
		Reply checkStreet = new Reply();
		
		checkStreet.setStreetNo(streetNo);
		checkStreet.setMemberNo(loginMember.getMemberNo());
		
		System.out.println("골목번호 : " + streetNo);
		System.out.println("로그인정보 : " + loginMember.getMemberNo());
		
		//System.out.println("프로필사진정보 : " + loginMember.getMemberProfileUrl());

		model.addAttribute("streetNo", streetNo);

		String beforeUrl = request.getHeader("referer");

		try {
			Street street = streetService.selectStreet(streetNo);

			List<Board> board = streetService.selectBoard(checkStreet);
			Collections.reverse(board);
			
			List<Reply> reply  = streetService.selectReply(checkStreet);

			for(int i = 0 ; i < board.size(); i++ ) {
				System.out.println(board.get(i));
			}
			
			for(int i = 0 ; i < reply.size(); i++ ) {
				System.out.println(reply.get(i));
			}
			
			//System.out.println(reply);
			
			if (street != null) {

				//model.addAttribute("street", street);  사용안함
				model.addAttribute("board", board);
				model.addAttribute("reply", reply);
				model.addAttribute("reReply", reply);

				
				model.addAttribute("loginMember", loginMember);

				return "street/streetMain";

			} else {
				rdAttr.addFlashAttribute("msg", "골목 상세 조회 실패");
				return "redirect:" + beforeUrl;
			}

		} catch (Exception e) {
			e.printStackTrace();
			return "redirect:" + beforeUrl;
		}

	}

	// 게시글 작성
	@RequestMapping("insert")
	public String insertBoard(Board board, Model model, HttpServletRequest request, 
			RedirectAttributes rdAttr,
			@RequestParam(value = "images", required = false) List<MultipartFile> images) {

		Member loginMember = (Member) model.getAttribute("loginMember");
		System.out.println(loginMember);
		int boardWriter = loginMember.getMemberNo();
		System.out.println(boardWriter);

		int streetNo = (int) model.getAttribute("streetNo");
		System.out.println(streetNo);

		board.setBoardContent(board.getBoardContent().replace("\r\n", "<br>"));
		board.setMemberNo(boardWriter);
		board.setStreetNo(streetNo);
		board.setTypeNo(0);

		System.out.println("등록할 게시글 : " + board);

		try {

			int result = streetService.insertBoard(board);

			if (result > 0)
				System.out.println("게시글 등록 성공" + result);
			else
				System.out.println("게시글 등록 실패" + result);

			return "redirect:streetMain?streetNo=" + streetNo;

		} catch (Exception e) {
			e.printStackTrace();
			return "redirect:streetMain?streetNo=" + streetNo;

		}

	}

	// 게시글 좋아요 등록, 해제
	@ResponseBody
	@RequestMapping("likeFunction")
	public String likeFunction(int postNo, Model model) {

		Member loginMember = (Member) model.getAttribute("loginMember");

		System.out.println("글번호 출력 : " + postNo);
				
		Reply reply = new Reply();
		reply.setMemberNo(loginMember.getMemberNo());
		reply.setBoardNo(postNo);

		try {

			return streetService.likeCheck(reply) == 1 ? true + "" : false + "";

		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("errorMsg", "좋아요 기록 과정에서 오류발생");
			return "/common/errorPage";
		}
	}
	
	// 댓글 좋아요 등록, 해제
	@ResponseBody
	@RequestMapping("replyLikeFunction")
	public String replyLikeFunction(int replyNo, int boardNo, Model model) {

		Member loginMember = (Member) model.getAttribute("loginMember");

		System.out.println("댓글번호 출력 : " + replyNo);
		
		Reply reply = new Reply();

		// 게시글 번호 
		
		// memberAge에 게시글 번호 담아서 재활용
		reply.setReplyNo(replyNo);
		reply.setMemberNo(loginMember.getMemberNo());
		reply.setBoardNo(boardNo);

		try {

			return streetService.replyLikeFunction(reply) == 1 ? true + "" : false + "";

		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("errorMsg", "좋아요 기록 과정에서 오류발생");
			return "/common/errorPage";
		}
	}
	
	// 대댓글 좋아요 등록, 해제
		@ResponseBody
		@RequestMapping("reReplyLikeFunction")
		public String reReplyLikeFunction(int replyNo, int boardNo, Model model) {

			Member loginMember = (Member) model.getAttribute("loginMember");

			System.out.println("대댓글번호 출력 : " + replyNo);
			
			Reply reply = new Reply();

			// 게시글 번호 
			
			// memberAge에 게시글 번호 담아서 재활용
			reply.setReplyNo(replyNo);
			reply.setMemberNo(loginMember.getMemberNo());
			reply.setBoardNo(boardNo);

			try {

				return streetService.reReplyLikeFunction(reply) == 1 ? true + "" : false + "";

			} catch (Exception e) {
				e.printStackTrace();
				model.addAttribute("errorMsg", "좋아요 기록 과정에서 오류발생");
				return "/common/errorPage";
			}
		}


	// 게시글 삭제
	@ResponseBody
	@RequestMapping("deletePost")
	public String deletePost(int postNo, Model model) {

		System.out.println("글삭제 번호 출력 : " + postNo);

		try {

			int test = streetService.deletePost(postNo);

			return test == 1 ? true + "" : false + "";

		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("errorMsg", "게시글 삭제 과정에서 오류발생");
			return "/common/errorPage";
		}
	}
	
	// 댓글 작성
	@ResponseBody
	@RequestMapping("writeComment")
	public String writeComment(int postNo, Model model, String commentContent) {
		
		System.out.println("댓글 달릴 게시글  번호 출력 : " + postNo);
		
		Member loginMember = (Member)model.getAttribute("loginMember");
		
		Reply reply = new Reply();
		
		System.out.println("댓글 입력 내용 : " + commentContent );
		
		reply.setBoardNo(postNo);
		reply.setMemberNo(loginMember.getMemberNo());
		reply.setReplyContent(commentContent);
	
		try {
	
			int test = streetService.writeComment(reply);
			
			if ( test > 0) {
				System.out.println("댓글 입력 완료");
			}else {
				System.out.println("댓글 입력 실패");
			}
			
			return  test == 1 ? true + "" : false + "";
			
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("errorMsg", "게시글 삭제 과정에서 오류발생");
			return "/common/errorPage";
		}
	}
	
		// 대댓글 작성
		@ResponseBody
		@RequestMapping("writeReComment")
		public String writeReComment(int replyNo, Model model, String commentContent, int boardNo) {
			
			System.out.println("대댓글 달릴 댓글 번호 출력 : " + replyNo);
			
			Member loginMember = (Member)model.getAttribute("loginMember");
			
			Reply reply = new Reply();
			
			System.out.println("댓글 입력 내용 : " + commentContent );
			
			reply.setReReplyNo(replyNo);
			reply.setMemberNo(loginMember.getMemberNo());
			reply.setReplyContent(commentContent);
			reply.setBoardNo(boardNo);
		
			try {
		
				int test = streetService.writeReComment(reply);
				
				if ( test > 0) {
					System.out.println("대댓글 입력 완료");
				}else {
					System.out.println("대댓글 입력 실패");
				}
				
				return  test == 1 ? true + "" : false + "";
				
			} catch (Exception e) {
				e.printStackTrace();
				model.addAttribute("errorMsg", "대댓글 입력 과정에서 오류발생");
				return "/common/errorPage";
			}
		}
	
	
	// 작성자 프로필 클릭시 회원 정보 조회
    @ResponseBody
	@RequestMapping("checkProfile")
    public ArrayList<Object>  checkProfile(HttpServletResponse response, int memberNo) {
    	ArrayList<Object> mList = new ArrayList<Object>();
    	
    	System.out.println("작성자 얻어온 정보 : " + memberNo);
    	try {
    		
        	// 1) 회원 정보 가져오기
    		Member member = streetService.checkProfile(memberNo);
    		System.out.println("작성자 조회한 정보 : " + member);
    		mList.add(member); // 0번 인덱스에 회원정보
    		
        	// 2) 회원 관심사 가져오기
    		List<Hobby> myHobby = streetService.selectHobby(memberNo);
			for(int k=0;k<myHobby.size();k++) {
				System.out.println("작성자 관심사 : " + myHobby.get(k));
				mList.add(myHobby.get(k)); // 1~3번 인덱스에 회원 관심사
			}
			
			for(int i=0;i<mList.size();i++) {
				System.out.println("작성자 회원 : " + mList.get(i));
			}
			
			response.setCharacterEncoding("UTF-8");
			new Gson().toJson(mList, response.getWriter());
    		
    	} catch(Exception e) {
    		e.printStackTrace();
    	}
    	return null;
    }
	
	// -------------------------------------------- 중하 끝  ---------------------------------------------
	// -------------------------------------------- 지원 -----------------------------------------------
	// 골목 개설 화면 이동
	@RequestMapping("streetInsert")
	public String insertStreetForm(Model model) {
		
		// 회원 번호 얻어오기
		Member loginMember = (Member)model.getAttribute("loginMember");
		int memberNo = loginMember.getMemberNo();
				
		String msg = null; 
		int result = 0;
		
		try {
						
			result = streetService.selectMyStreet(memberNo);
			
			if (result > 0) {
				
				return "street/streetInsert";
			}

			else {
				msg = "골목 개설 불가";
				model.addAttribute("msg", msg);
				return "redirect:/square";
			}
			
		}catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("errorMsg", "골목 개설 화면 이동 과정에서 오류 발생");
			return "/common/errorPage";
		}
	
	}

	// 골목 개설
	@RequestMapping("insertStreet")
	public String insertStreet(Street street,
			@RequestParam(value = "streetKeywords", required = false) String[] streetKeywords,
			@RequestParam(value = "sampleImg", required = false) String sampleImg,
			@RequestParam(value = "streetCoverUpload", required = false) MultipartFile streetCoverUpload,
			HttpServletRequest request, RedirectAttributes rdAttr, Model model) {

		// 회원 번호 얻어오기
		Member loginMember = (Member) model.getAttribute("loginMember");
		int memberNo = loginMember.getMemberNo();

		// 골목 커버
		String root = request.getSession().getServletContext().getRealPath("resources");
		String savePath = root + "/" + "streetCoverImage";
		File folder = new File(savePath);
		if (!folder.exists())
			folder.mkdir();
				 
		String msg = null;
		int result = 0;

		try {
						
			if(!sampleImg.equals("")) {
								
				if(sampleImg.equals("골목.jpg")) {					
					street.setImgNo(6);
				} else if(sampleImg.equals("골목2.jpg")) {
					street.setImgNo(7);
				} else if(sampleImg.equals("골목3.jpg")) {
					street.setImgNo(8);
				} else if (sampleImg.equals("골목4.jpg")) { 
					street.setImgNo(9);
				}
								
				result = streetService.insertStreet1(street, memberNo, streetKeywords);
				
			} else if(sampleImg.equals("") && !streetCoverUpload.getOriginalFilename().equals("")) {
				
				// 골목 커버 이름 바꾸기
				String changeCoverName = FileRename.rename(streetCoverUpload.getOriginalFilename());

				result = streetService.insertStreet2(changeCoverName, street, memberNo, streetKeywords);
				
				if (result > 0) { // 정보 다 저장된 경우 골목 커버 서버에 저장

					streetCoverUpload.transferTo(new File(savePath + "/" + changeCoverName));
					 
				}
			}

			if(result > 0) {
				msg = "골목 개설 성공~!! 우르르ㄱ끼기ㅣ긱";
				model.addAttribute("msg", msg);
				return "redirect:/square"; // 골목으로 이동하게 바꾸기
			} else {
				
				msg = "골목 개설 실패했다ㅠㅠ 흐규흐규";
				model.addAttribute("msg", msg);
				return "redirect:/square";
			}

		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("errorMsg", "골목 개설 과정에서 오류 발생");
			return "common/errorPage";
		}
	}
	// -------------------------------------------- 지원 끝 -----------------------------------------------
	
	// 추천 친구 페이지 이동 ----> 기능 만들어야함
	@RequestMapping("recommendFriend")
	public String recommendFriend(Model model) {
		int streetNo = (int) model.getAttribute("streetNo");
		Member loginMember = (Member)model.getAttribute("loginMember");
		try {
			List<Hobby> myHobby = streetService.selectHobby(loginMember.getMemberNo());
			
			System.out.println(myHobby);
			List<Member> mList = null;
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("streetNo", streetNo);
			/*---------태훈 수정---------*/
			char[] status = {'Y'};
			map.put("status", status);
			/*---------태훈 수정 끝---------*/
			if(!myHobby.isEmpty() && myHobby != null) {
				map.put("myHobby", myHobby);
				mList = streetService.selectJuminList(map);
			}
			
			List<Hobby> hList = null;
			
			if(mList != null && !mList.isEmpty()) {
				hList = streetService.selectHobbyList(mList);
			}
			
			System.out.println(mList);
			System.out.println(hList);
			
			model.addAttribute("mList", mList);
			model.addAttribute("hList", hList);
			return "street/recommendFriend";
			
			
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("errorMsg", "추천 친구 조회 과정에서 오류 발생");
			return "common/errorPage";
		}
			
	}

	// 골목 가입
	@ResponseBody
	@RequestMapping("streetJoin")
	public int streetJoin(Model model) {
		int streetNo = (int) model.getAttribute("streetNo");
		Member member = (Member) model.getAttribute("loginMember");
		int memberNo = member.getMemberNo();
		
		int myStreetCount = streetService.myStreetCount(memberNo);
		
		if(myStreetCount >= 3) {
			return -1;
		}

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("streetNo", streetNo);
		map.put("memberNo", memberNo);

		int result = streetService.streetJoin(map);
		
		if(result > 0) {
			// 알람 테이블에 데이터 삽입
			// 가입 신청한 골목의 골목대장 번호 가져오기
			int masterNo = streetService.selectMasterNo(streetNo);
			Alarm alarm = new Alarm("골목 가입 요청", '1', "street/joinCheck?memberNo="+memberNo, memberNo+"", masterNo);
			result = streetService.insertAlarm(alarm);
		}

		return result;

	}
	
	// 주민목록 조회
	@RequestMapping
	public String juminList(Model model) {
		int streetNo = (int) model.getAttribute("streetNo");
		Member loginMember = (Member)model.getAttribute("loginMember");
		try {
			
			List<Member> mList = null;
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("streetNo", streetNo);
			/*---------태훈 수정---------*/
			char[] status = {'Y', 'W'};
			map.put("status", status);
			/*---------태훈 수정 끝---------*/
			mList = streetService.selectJuminList(map);
			
			List<Hobby> hList = null;
			
			if(mList != null && !mList.isEmpty()) {
				hList = streetService.selectHobbyList(mList);
			}
			
			
			System.out.println(mList);
			System.out.println(hList);
			
			model.addAttribute("mList", mList);
			model.addAttribute("hList", hList);
		}catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("errorMsg", "주민 목록 조회 과정에서 오류 발생");
			return "common/errorPage";
		}
		
		return "street/juminList";
	}
	
	@ResponseBody
	@RequestMapping("addFriend")
	public void addFriend(Model model, int yourNum) {
		Member loginMember = (Member)model.getAttribute("loginMember");
		int myNum = loginMember.getMemberNo();
		Relationship addRelation = new Relationship(myNum, yourNum, '1');
		
		streetService.addRelation(addRelation);
    
	}
		
	
	// 썸머노트 파일 DB삽입용
	@ResponseBody
	@RequestMapping("fileUpload")
	public void fileUpload(Board board, 
			Model model, 
			MultipartFile file, 
			HttpServletRequest request, 
			HttpServletResponse response) {
		
		String root = request.getSession().getServletContext().getRealPath("/");
		String savePath = root + "resources\\uploadImages\\";
		int maxSize = 1024 * 1024 * 10;

		
		
		Member loginMember = (Member) model.getAttribute("loginMember");
		//System.out.println(loginMember);
		try {
			int result = streetService.fileUpload(board,file,request,response);
			
			if (result > 0)
				System.out.println("썸머노트 등록 성공" + result);
			else
				System.out.println("썸머노트 등록 실패" + result);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	/*------------------------ 태훈 시작 (03/22) -----------------------------------*/
	/** 골목 가입 허가/거절 용 Controller
	 * @param model
	 * @param applyCheck
	 * @param memberNo
	 * @return result
	 */
	@ResponseBody
	@RequestMapping("joinCheck")
	public int joinCheck(Model model, Boolean applyCheck, int memberNo) {
		System.out.println(memberNo);
		int streetNo = (int)model.getAttribute("streetNo");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("streetNo", streetNo);
		map.put("memberNo", memberNo);
		if(applyCheck == true) {
			streetService.joinCheck(map);
			return 1;
		} else {
			streetService.joinDelete(map);
			return 0;
		}
	}
	/*--------------------------------태훈 끝-------------------------------------*/
}
