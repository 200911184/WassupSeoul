<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

	<!-- 고정 사이드바 왼쪽 시작 -->
    <div class="col-md-2 fixed-top" style="left: 16.5%; top: 110px; background-color: rgb(255, 255, 255);">
    <!-- <div class="col-md-2 fixed-top" style="left: 366px; top: 110px;" style="background-color: rgb(221, 233, 218);"> -->
      <div class="card mb-3" >
	      <div style="width: 100% !important; height: 200px; overflow: hidden; background-color:black;">
	        <img style="height: 100%; width: 100%; object-fit: cover; display: block;" 
	        	src="${contextPath}/resources/streetCoverImage/${imgUrl}" alt="Card image">
	        </div>
        <div class="card-body">
          <div class="row">
            <div class="col-sm-10">
            	<input type="text" class="form-control-plaintext nanum" value="${street.streetNm}" style="font-size: 25px; font-weight: bold;">
			</div>
			<!-- 골목 등급을 나타내는 이미지 영역 시작 -->
            <div class="col-sm-2" style="padding: 0px;">
            	<img src="${contextPath}/resources/img/${badgeUrl}" alt="badge" style="height: auto; width: 40px; margin-top: 10px;">
            </div>
            <!-- 골목 등급을 나타내는 이미지 영역 끝 -->
          </div>
          <div class="row">
            <label class="col-sm-4 col-form-label nanum" style="font-weight: bold;font-size: 15px;">멤버</label>
            <div class="col-sm-8">
              <input type="text" readonly class="form-control-plaintext nanum" value="${citizenCount}" style="font-size: 15px;">
            </div>
            <label class="col-sm-4 col-form-label nanum" style="font-weight: bold;font-size: 15px;">골목대장</label>
            <div class="col-sm-8">
              <input type="text" readonly class="form-control-plaintext nanum" value="${streetMasterNm}" style="font-size: 15px;">
            </div>
            <label class="col-sm-4 col-form-label nanum" style="font-weight: bold;font-size: 15px;">활동점수</label>
            <div class="col-sm-8">
              <input type="text" readonly class="form-control-plaintext nanum" value="${street.streetPoint}" style="font-size: 15px;">
            </div>
          </div>
          <div style="margin:5px">
          	<textarea class="form-control nanum" rows="2" readonly style="resize: none;">${street.streetIntro}</textarea>
          </div>
          
          <c:forEach var="keyword" items="${streetKeyword}" varStatus="vs">
          	<div class="col-md-12 golmokKeywordBox" style="background-color: #F3969A; border-radius: 20px; margin-bottom: 5px;">
          		<input type="text" readonly class="form-control-plaintext nanum" value="#${keyword.keywordContent}" style="color: white;">
          	</div>
          </c:forEach>
          <!-- ㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁ태훈 수정 시작(03/24) pm 6:44 ㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁ -->
          <div class="row">
          	<c:if test="${citizenStatus eq 'N'}"> <!-- 정승환 추가코드(20.03.26) -->
	           <div class="col-sm-12" style="margin-top:5px;margin-bottom:5px">
	           	<button type="button" class="btn btn-primary btn-lg btn-block nanum" style="font-size: 20px; font-weight: bold;"
				id="streetJoin">골목 가입하기</button>
	           </div>
            </c:if>
            <c:if test="${citizenStatus eq 'W'}">
	            <div class="col-sm-12" style="margin-top:5px;margin-bottom:5px">
	            	<button type="button" class="btn btn-warning btn-lg btn-block nanum" style="font-size: 20px; font-weight: bold;"
	            	id="joinCancel">골목 가입요청중</button>
	            </div>
            </c:if>
            <c:if test="${citizenStatus ne 'N' && citizenStatus ne 'W'}"> <!-- 정승환 추가코드(20.03.26) -->
            	<div class="col-sm-12" style="margin-top:5px;margin-bottom:5px">
	            	<button type="button" class="btn btn-info disabled btn-lg btn-block nanum" style="font-size: 20px; font-weight: bold;"
	            	disabled>골목 가입완료</button>
	            </div>
            </c:if>
          </div>
          <script>
			$(document).on("click", "#streetJoin", function(){
				if (confirm("가입을 신청하시겠습니까?")) {
					$.ajax({
						url : "${contextPath}/street/streetJoin",
						success : function(result) {
							if (result == -1) {
								alert("더 이상 골목에 가입할 수 없습니다");
							} else {
								alert("골목 가입 요청 완료");
								$("#streetJoin").off("click");
								$("#streetJoin").text("골목 가입요청중");
								$("#streetJoin").prop("class", "btn btn-warning btn-lg btn-block nanum");
								$("#streetJoin").prop("id", "joinCancel");
								sendAlarm(result);
							}
						},
						error : function() {
							alert("골목 가입 신청 과정 중 오류 발생");
						}
					});
					//sendAlarm("74");
				}
			})
			
			$(document).on("click", "#joinCancel", function(){
				$.ajax({
					url : "${contextPath}/street/joinCancel",
					success : function(result) {
						console.log("골목 가입 취소 ajax 성공");
						if(result == 0){
							alert("골목 가입 취소 실패");
						} else {
							$("#joinCancel").off("click");
							$("#joinCancel").text("골목 가입");
							$("#joinCancel").prop("class","btn btn-primary btn-lg btn-block nanum");
							$("#joinCancel").prop("id", "streetJoin");
						}
						
					},
					error : function() {
						console.log("골목 가입 취소 ajax 실패");
					}
				})
			})
			<!-- ㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁ태훈 수정 끝 ㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁ -->
		  </script>
		  <div class="row">
				<c:if test="${citizenGrade eq 'M'}">
					<div class="col-sm-6">
						<a onclick="return confirm('정말로 이 골목을 삭제하시겠습니까?');"
							href="streetDelete?streetNo=${streetNo}" class="btn btn-link nanum"
							style="color: red; font-weight: bold; font-size: 15px"> <img
							src="${contextPath}/resources/img/streetOut.svg" alt="이미지"
							style="width: 15px; height: 15px;"> 골목 삭제
						</a>
					</div>
					<div class="col-sm-6" style="padding: 0px; padding-left: 12px;">
						<a href="newMaster?streetNo=${streetNo}" class="btn btn-link nanum"
							style="color: red; font-weight: bold; font-size: 15px"> <img
							src="${contextPath}/resources/img/streetOut.svg" alt="이미지"
							style="width: 15px; height: 15px;"> 대장위임
						</a>
					</div>
				</c:if>
				<!-- 일반 주민 영역 -->
		  	<c:if test="${citizenGrade eq 'G'}">
	           	<div class="col-sm-6" style="padding: 0px; padding-left: 12px;">
	             		<a href="${contextPath}/street/secessionStreet" onclick="return secessionValidate();" class="btn btn-link nanum" style="color : red; font-weight : bold; font-size: 15px">
	               	<img src="${contextPath}/resources/img/streetOut.svg" alt="이미지" style="width: 15px; height: 15px;">
	              	 	골목 탈퇴
	             		</a>
	           	</div>
		  	</c:if>
            <!-- 일반 주민 영역 -->
            
            <!-- 골목대장 영역 -->
           <c:if test="${citizenGrade eq 'M'}"> 
		  	    	<div class="col-sm-6" style="padding: 0px; padding-left: 12px;">
	             		<a href="streetUpdate?streetNo=${streetNo}" class="btn btn-link nanum" style="font-weight : bold; font-size: 15px">
	               	<img src="${contextPath}/resources/img/streetChange.svg" alt="이미지" style="width: 15px; height: 15px;">
	                                   	골목 변경
	             		</a>
	           	</div>
	           	<div class="col-sm-6" style="padding: 0px; padding-left: 12px;">
	             		<a href="streetReport" class="btn btn-link nanum" style="font-weight : bold; font-size: 15px; padding-left: 6px; padding-right: 6px;">
	               	<img src="${contextPath}/resources/img/actReport.svg" alt="이미지" style="width: 15px; height: 15px;">
	                                   	활동보고서
	             		</a>
	           	</div>
	  	    </c:if>
            <!-- 골목대장 영역 -->
            
          </div>
        </div>
        <script>
        	function secessionValidate(){
        		if(confirm("정말 골목에서 탈퇴하시겠습니까?")){
        			return true;
        		} else {
        			return false;
        		}
        	}
        </script>
       <c:if test="${street.streetPublic eq 'Y'.charAt(0)}">
        	<div class="card-footer nanum">
          	누구나 골목을 검색해 찾을 수 있고, <br>게시물을 볼 수 있습니다.
        	</div>
        </c:if>
        <c:if test="${street.streetPublic eq 'N'.charAt(0)}">
        	<div class="card-footer nanum">
         	 이 골목은 누구나 검색해 찾을 수 있지만, 게시물은 주민만 볼 수 있습니다.
        	</div>
        </c:if>
        
      </div>
    </div>
    <!-- 고정사이드바 왼쪽 끝 -->

    <!-- 고정사이드바 오른쪽 시작 -->
    <div class="col-md-2 fixed-top" style="left: 67%; top: 110px; opacity: 1.0; z-index: 0">
    <!-- <div class="col-md-2 fixed-top" style="left: 1223px; top: 110px;"> -->
    	<div class="card border-primary mb-3" style="max-width: 20rem;">
			<div class="card-header nanum" style="font-size: 25px;">다가오는 일정</div>
			<div class="card-body" style="padding-bottom:10px;">
				<h4 class="card-title nanum" style="font-weight: bolder;" id="sideMonth"></h4>
				<!-- 정승환 추가코드 시작(20.03.25) -->
				<c:if test="${empty setCalList}">
					<p class="card-text nanum">예정된 일정이 없습니다.</p>
				</c:if>
				<c:if test="${!empty setCalList}">
					<c:forEach var="calendar" items="${setCalList}" varStatus="vs">
						<p class="card-text nanum" style="margin-bottom: 0px;">${calendar.calStartDay} - ${calendar.calContent}</p> <!-- 정승환 코드수정(03.27) -->
					</c:forEach>
				</c:if>
				<!-- 정승환 추가코드 끝(20.03.25) -->
			</div>
		</div>
		<!-- 현재 월 입력 -->
		<script>
			var nowDate = new Date();
			$("#sideMonth").text((nowDate.getMonth()+1) + "월");
		</script>
		
     	<!-- 친구목록 버튼 -->
     	<%-- <div style="border-radius: 70%; background-color: gray; width: 100px; height: 100px; position: relative;">
			<div style="position: absolute; top: 15px; left: 20px;">
				<img src="${contextPath}/resources/img/iconmonstr-user-8-64.png" alt="이미지" style="cursor: pointer;">
			</div>
		</div> --%>

      <!-- 탑버튼 -->
      <%-- <a style="display: scroll; position: fixed; bottom: 10px; right: 10px;" href="#" title="맨 위로">
      	<img src="${contextPath}/resources/img/img_top.png" alt="탑버튼" style="width: 70px; height: 100px;">
	  </a> --%>

    </div>
    <%-- 아이콘 제작자 <a href="https://www.flaticon.com/kr/authors/phatplus" title="phatplus">phatplus</a> from <a href="https://www.flaticon.com/kr/" title="Flaticon"> www.flaticon.com</a> --%>
    <!-- 고정사이드바 오른쪽 끝 -->
