package com.kh.wassupSeoul.friends.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.google.gson.Gson;
import com.kh.wassupSeoul.friends.model.service.FriendsService;
import com.kh.wassupSeoul.member.model.vo.Member;

@SessionAttributes({"loginMember","msg"})
@RequestMapping("/friends/*")
@Controller
public class FriendsController {

	@Autowired
	private FriendsService friendsService;
	
	// 친구요청 목록 조회용 Controller
	@ResponseBody
	@RequestMapping(value = "friendRequest", method = RequestMethod.POST,
			produces = "application/json; charset=utf-8")
	public String friendRequest(Model model, HttpServletResponse response) {
		int myNum = ((Member)model.getAttribute("loginMember")).getMemberNo();
		try {
			List<Member> fList = friendsService.friendRequest(myNum);
			return new Gson().toJson(fList);
		} catch (Exception e){
			e.printStackTrace();
		}
		return null;
	}// 목록 조회 끝
	
	
	// 친구 추가 Controller
	@ResponseBody
	@RequestMapping(value = "addFriend", method = RequestMethod.POST)
	public String friendGo(Model model, int yourNo) {
		int myNo = ((Member)model.getAttribute("loginMember")).getMemberNo();
		 
		try {
			Map<String, Object> nMap = new HashMap<String, Object>();
			nMap.put("myNo", myNo);
			nMap.put("yourNo", yourNo);
			
			int result = friendsService.addFriend(nMap);
			
			if (result>0) {
				//System.out.println("친구추가 성공");
			} else {
				//System.out.println("친구등록 실패");
			}
			return null;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
		
	} // 친구 추가 끝 
	
	
	// 친구 거절 Controller
	@ResponseBody
	@RequestMapping(value = "rejectFriend", method = RequestMethod.POST)
	public String friendNo(Model model, int yourNo) {
		int myNo = ((Member)model.getAttribute("loginMember")).getMemberNo();
		 
		try {
			Map<String, Object> nMap = new HashMap<String, Object>();
			nMap.put("myNo", myNo);
			nMap.put("yourNo", yourNo);
			
			int result = friendsService.friendNo(nMap);
			
			if (result>0) {
				//System.out.println("친구거절 성공");
			} else {
				//System.out.println("친구거절 실패");
			}
			return null;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
		
		
	} // 친구 거절 끝 
	 
	
	// 친구 차단 Controller
	@ResponseBody
	@RequestMapping(value="blockFriend", method = RequestMethod.POST)
	public String blockFriends(Model model, int yourNo) {
		int myNo = ((Member)model.getAttribute("loginMember")).getMemberNo();
		 System.out.println("컨트롤러 오는건가?");
		try {
			Map<String, Object> nMap = new HashMap<String, Object>();
			nMap.put("myNo", myNo);
			nMap.put("yourNo", yourNo);
			
			int result = friendsService.blockFriend(nMap);
			
			if (result>0) {
				System.out.println("친구 차단 성공");
			} else {
				System.out.println("친구 차단 실패");
			}
			return null;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
		}
	
	
	
	// 친구 목록 조회 Controller
	@ResponseBody
	@RequestMapping(value="friendsList", method = RequestMethod.POST,
			produces = "application/json; charset=utf-8")
	public String friendList(Model model) {
		
		int myNum = ((Member)model.getAttribute("loginMember")).getMemberNo();
		try {
			List<Member> fList = friendsService.friendsList(myNum);
			return new Gson().toJson(fList);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	} // 친구목록 조회 끝
	
	
	
	
	
	
	
	
	
	
	
	
}
