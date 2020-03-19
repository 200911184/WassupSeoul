<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<c:set var="contextPath" value="${pageContext.servletContext.contextPath }" scope="application"/>
<link rel="stylesheet" href="${contextPath}/css/bootstrap.css" type="text/css">
<link rel="stylesheet" href="${contextPath}/css/common.css" type="text/css">
<script src="https://code.jquery.com/jquery-3.4.1.min.js"
		integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
		crossorigin="anonymous"></script>
<title>header</title>
<style>
.profileBox{
  width: 100%;
  height: 120px; 
  border-radius: 70%;
  overflow: hidden;
}
.profileImage{
width: 100%;
height: 100%;
object-fit: cover;
}
</style>
</head>
<body class="nanum">
	
	<c:if test="${!empty msg}">
		<script>alert("${msg}")</script>
		<c:remove var="msg"/>
	</c:if>
	
	<c:url var="detailUrl" value="square">
		<c:param name="currentPage" value="1" />
		<c:if test="${!empty param.districtNo}">
			<c:param name="districtNo" value="${param.districtNo}" />
		</c:if>
		<c:if test="${!empty param.streetSort}">
			<c:param name="streetSort" value="${param.streetSort}" />
		</c:if>
	</c:url>
	<nav
		class="navbar navbar-expand-lg navbar-dark bg-primary fixed-top headerOpacity">
		<%-- <form class="form-inline my-2 my-lg-0" action="${contextPath }/square"
			onsubmit="return searchValidate();"> --%>
			<input class="form-control mr-sm-2" type="text"
				placeholder="검색할 골목 키워드" id="searchStreet" name="searchStreet"
				style="width: 300px">
			<button class="btn btn-secondary my-2 my-sm-0" type="button"
			 		onclick="searchValidate()">Search</button>
		<!-- </form> -->
		<script>
			function searchValidate() {
				/* alert("${param.districtNo}")
				alert("${param.streetSort}") */
				var regExp = /^[\w가-힣]{2,}$/;
				var searchStreet = $("#searchStreet").val();
				console.log(searchStreet);
				if (!regExp.test(searchStreet)){
					alert("2글자 이상의 완성된 글자를 입력해주세요.");
				} else {
					location.href = "${detailUrl}&searchStreet=" + searchStreet;
				}
			}
		</script>
		<div class="collapse navbar-collapse">
			<ul class="navbar-nav mr-auto">
			</ul>


			<div class="dropdown">
				<div class="dropdown-toggle headerImg" type="button"
					id="alarmButton" data-toggle="dropdown" aria-haspopup="true"
					aria-expanded="false">
					<img src="${contextPath}/resources/img/alarm2.png">
				</div>
				<div class="dropdown-menu dropdown-menu-right"
					aria-labelledby="alarmButton">
					<a class="dropdown-item nanum" data-toggle="modal">'조미현'님이 친구요청을 수락하셨습니다.</a> 
					<a class="dropdown-item nanum" data-toggle="modal">'20대 인싸들' 골목에서 추방당하셨습니다.</a>
				</div>
			</div>


			<div class="dropdown">
				<div class="dropdown-toggle headerImg" type="button"
					id="mypageButton" data-toggle="dropdown" aria-haspopup="true"
					aria-expanded="false">
					<img src="${contextPath}/resources/profileImage/${loginMember.memberProfileUrl}">
				</div>
				<div class="dropdown-menu dropdown-menu-right"
					aria-labelledby="mypageButton">
					<a class="dropdown-item nanum" data-toggle="modal" data-target="#profileModal" id="abcde">내정보 조회</a> 
					<a class="dropdown-item nanum" data-toggle="modal" data-target="#golmokModal">내골목 조회</a>
					<a class="dropdown-item nanum" data-toggle="modal">1:1 문의</a> 
					<a class="dropdown-item nanum" data-toggle="modal">공지사항</a>
					<hr>
					<a class="dropdown-item nanum" href="${contextPath}/member/logout">로그아웃</a>
				</div>
			</div>
		</div>
	</nav>
	
	
	
	<!-- profile Modal -->
    <div class="modal fade" id="profileModal" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="profileModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
            <h2 class="modal-title nanum" id="profileModalLabel" style="font-weight: bold;">내정보 조회</h2>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          	<span aria-hidden="true">&times;</span>
        	</button>
            </div>
            <div class="modal-body">
            <!-- content start -->
                <!-- profile image start -->
                <div class="row">
                <div class="col-md-4"></div>
                <div class="col-md-4">
                    <div class="profileBox">
                    <img class="profileImage" src="" alt="이미지" id="memberProfileUrl">
                    </div>
                </div>
                <div class="col-md-4"></div>
                </div>
                <!-- profile image end-->
                <div class="row">
                <div class="col-md-3"></div>
                <div class="col-md-6">
                    <input type="text" id="memberNickName" class="nanum form-control-plaintext text-center" style="font-size: 35px;font-weight: bold;" readonly>
                </div>
                <div class="col-md-3"></div>
                </div>
                <div class="row">
                <div class="col-md-2"></div>
                <div class="col-md-8"><input type="text" id="memberEmail" class="nanum form-control-plaintext text-center" style="font-size: 25px;font-weight: bold;" readonly></div>
                <div class="col-md-2"></div>
                </div>
                <div class="row">
                <label class="col-sm-2 col-form-label text-center nanum" style="font-weight: bold; font-size: 16px;">이름</label>
                <div class="col-sm-4">
                    <input type="text" readonly id="memberName" class="nanum form-control-plaintext text-center"  style="font-size: 25px;">
                </div>
                <label class="col-sm-2 col-form-label text-center nanum" style="font-weight: bold; font-size: 16px;">나이</label>
                <div class="col-sm-4">
                    <input type="text" readonly id="memberAge" class="nanum form-control-plaintext text-center" style="font-size: 25px;">
                </div>
                </div>

                <div class="row">
                <label class="col-sm-2 col-form-label text-center nanum" style="font-weight: bold; font-size: 16px;">성별</label>
                <div class="col-sm-4">
                	<input type="text" readonly id="memberGender" class="nanum form-control-plaintext text-center" style="font-size: 25px;">
                </div>
                <label class="col-sm-2 col-form-label text-center nanum" style="font-weight: bold; font-size: 16px;">전화번호</label>
                <div class="col-sm-4">
                    <input type="text" readonly id="memberPhone" class="nanum form-control-plaintext text-center" style="font-size: 22px;">
                </div>
                </div>

                <div class="row" id="memberProfileHobby">
              	<!-- 관심사 영역 -->
                </div>
            
                <div class="row">
                <div class="col-md-6">
                    <a class="btn btn-primary btn-lg btn-block nanum" href="${contextPath}/member/updateForm" role="button" style="font-weight: bold;">내정보 수정</a>
                </div>
                <div class="col-md-6">
                    <a class="btn btn-primary btn-lg btn-block nanum" href="${contextPath}/member/deleteForm" role="button" style="font-weight: bold;">회원 탈퇴</a>
                </div>
                </div>
                <!-- content end -->
                </div>
            </div>
            </div>
        </div>
        <!-- end -->
        
        <!-- golmok Modal -->
        <div class="modal fade" id="golmokModal" data-backdrop="static" tabindex="-1" role="dialog" aria-labelledby="golmokModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                <h2 class="modal-title nanum" id="golmokModalLabel" style="font-weight: bold;">내골목 조회</h2>
                </div>
                <div class="modal-body">
                <!-- content start -->
                <div class="container-fluid">
					<c:choose>
						<c:when test="${!empty myStreet}">
						<%-- 골목이 있는 경우 --%>
							<c:forEach var="street" items="${myStreet}" varStatus="vs">
								<!-- 골목 2 시작 -->
								<br>
			                    <div class="row">
			                    	<div class="col-md-4" style="position: relative">
				                        <img src="${contextPath}/resources/img/${street.imgUrl}" alt="이미지" width="100%" height="100%" style="position: absolute; z-index: 10;">
				                        <c:if test="${street.citizenGrade == 'M'.charAt(0) }">
				                        	<span class="badge badge-pill badge-info" style="position: absolute; z-index: 100; font-size:15px">개설 골목</span>
				                        </c:if>
				                        <%-- <img src="${contextPath}/resources/img/iconmonstr-certificate-3-48.png" style="position: absolute; z-index: 100;"> --%>
				                    </div>
				                    <div class="col-md-1"></div>
				                    <div class="col-md-7">
				                        <div class="row">
				                        <div class="col-md-9"><input type="text" readonly class="form-control-plaintext nanum" value="${street.streetNm}" style="font-weight: bold;font-size: 25px;"></div>
				                        <div class="col-md-3"><button type="button" class="btn btn-outline-success text-center" disabled style="font-size: 13px;font-weight: bold;">${street.districtNm}</button></div>
				                        </div>
				                        <div class="row">
				                        <div class="col-md-12"><textarea rows="2" cols="65" style="resize: none;" class="form-control" readonly>${street.streetIntro}</textarea></div>
				                        </div>
				                        <%-- 키워드 작성 부분 시작--%>
				                        <c:forEach var="streetKeyword" items="${myStreetKeyword}" varStatus="vs">
				                        	<c:if test="${street.streetNo eq streetKeyword.streetNo}">
				                        		<div class="row">
					                        		<div class="col-md-12 golmokKeywordBox mt-1 mb-1" style="background-color: #36be81;">
					                        			<input type="text" readonly class="form-control-plaintext nanum" value="#${streetKeyword.keywordContent}" style="color: white;">
					                       			</div>
				                       			</div>
				                        	</c:if>	
				                        </c:forEach>
				                    	<%-- 키워드 작성 부분 끝--%>
				                        <div class="row">
				                        <label class="col-sm-3 col-form-label text-center nanum" style="font-weight: bold; font-size: 16px;">골목 총 인원</label>
				                        <div class="col-sm-3"><input type="text" readonly class="nanum form-control-plaintext" value="${street.streetMaxMember}" style="font-size: 25px;"></div>
				                        <label class="col-sm-3 col-form-label text-center nanum" style="font-weight: bold; font-size: 20px;">골목대장</label>
				                        <div class="col-sm-3"><input type="text" readonly class="nanum form-control-plaintext" value="${street.memberNm}" style="font-size: 25px;"></div>
				                        </div>
				                        <div class="row">
				                        <div class="col-md-12"><button type="button" class="btn btn-primary btn-lg btn-block nanum" style="font-weight: bold;">골목 이동</button></div>
				                        </div>
				                    </div>
			                    </div>
			                    <!-- 골목 2 끝 -->
							</c:forEach> 	 
						</c:when>
						<c:otherwise>
						<%-- 골목이 없는 경우 --%>
						<h4 class="nanum">가입한 골목이 없습니다.</h4>
						</c:otherwise>
					</c:choose>
					
                      
                    
                </div>
                <!-- content end -->
                </div>
                <div class="modal-footer">
                <button type="button" class="btn btn-secondary nanum" data-dismiss="modal" style="font-weight: bold;">나가기</button>
                </div>
            </div>
            </div>
        </div>
        <!-- end -->
        
        <script>
		/* 내정보 조회용 회원정보,회원관심사 DB조회용 ajax */
       	$("#abcde").on("click",function(){
       		$.ajax({
       			url : "${contextPath}/member/selectProfileMember",
       			data : {memberEmail : "${loginMember.memberEmail}" , memberNo : ${loginMember.memberNo} },
       			type : "post",
       			dataType : "json",
       			success : function(mList){
       				
       				// 회원정보
       				$("#memberProfileUrl").prop("src","${contextPath}/resources/profileImage/"+mList[0].memberProfileUrl);
       				$("#memberNickName").val(mList[0].memberNickname);
       				$("#memberEmail").val(mList[0].memberEmail);
       				$("#memberName").val(mList[0].memberNm);
       				$("#memberAge").val(mList[0].memberAge);
       				$("#memberPhone").val(mList[0].memberPhone);
       				if(mList[0].memberGender == "M") {
       					$("#memberGender").val("남성");	
       				}else {
       					$("#memberGender").val("여성");
       				}
       				// 회원정보 끝
       				
            		// 회원 관심사
       				var $divPlus = $("#memberProfileHobby");
            		
       				for(var i=1;i<Object.keys(mList).length;i++){
       					if(i == 1) { // 제일 처음 관심사
       						var $divPlus1 = $("<div class='col-sm-10'>");
       	       				var $labelPlus = $("<label>");
       	       				var $inputPlus = $("<input>");
       						$labelPlus.addClass("col-sm-2 col-form-label text-center nanum").css({"font-weight" : "bold","font-size": "16px"}).html("관심분야");
       						$inputPlus.prop({"type":"text","readonly":"true"}).css({"color" : "blue","font-size": "25px"})
       								  .addClass("nanum form-control-plaintext").val("#" + mList[1].hobbyName);
       						$divPlus1.append($inputPlus);
       						if(document.getElementById("memberProfileHobby").childElementCount < 6) {
       							$divPlus.append($labelPlus);
           						$divPlus.append($divPlus1);	
       						}
       					} else { // 그 다음 관심사
       						var $divPlus1 = $("<div class='col-sm-10'>");
       	       				var $labelPlus = $("<label>");
       	       				var $inputPlus = $("<input>");
       						$labelPlus.addClass("col-sm-2 col-form-label text-center nanum").css({"font-weight" : "bold","font-size": "16px"});
       						$inputPlus.prop({"type":"text","readonly":"true"}).css({"color" : "blue","font-size": "25px"})
       								  .addClass("nanum form-control-plaintext").val("#" + mList[i].hobbyName);
       						$divPlus1.append($inputPlus);
       						if(document.getElementById("memberProfileHobby").childElementCount < 6) {
       							$divPlus.append($labelPlus);
           						$divPlus.append($divPlus1);	
       						}
       					}
       				}
       				// 회원 관심사 끝
       				
       			},
       			error : function(e){
           			console.log("ajax 통신 실패");
           			console.log(e);
           		}
       			
       		});
       		
       	});
    </script>
       
	<script
		src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"
		integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo"
		crossorigin="anonymous"></script>
	<script
		src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"
		integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6"
		crossorigin="anonymous"></script>
</body>
</html>