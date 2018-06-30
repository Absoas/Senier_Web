
<%@page import="DO.*"%>
<%@page import="bean.Db_connection"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="UTF-8" errorPage="addrbook_error.jsp"
	import="java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<style type="text/css">
.button {
	background: #1AAB8A;
	color: #fff;
	border: none;
	position: relative;
	height: 60px;
	font-size: 1.6em;
	padding: 0 2em;
	cursor: pointer;
	transition: 800ms ease all;
	outline: none;
	margin: 10px;
}

.button:hover {
	background: #fff;
	color: #1AAB8A;
}

.button:before, .button:after {
	content: '';
	position: absolute;
	top: 0;
	right: 0;
	height: 2px;
	width: 0;
	background: #1AAB8A;
	transition: 400ms ease all;
}

.button:after {
	right: inherit;
	top: inherit;
	left: 0;
	bottom: 0;
}

.button:hover:before, button:hover:after {
	width: 100%;
	transition: 800ms ease all;
}

table.table-style-two {
	font-family: verdana, arial, sans-serif;
	font-size: 11px;
	color: #333333;
	border-width: 1px;
	border-color: #6ADCBD;
	border-collapse: collapse;
}

table.table-style-two th {
	border-width: 1px;
	padding: 8px;
	border-style: solid;
	border-color: #6ADCBD;
	background-color: #6ADCBD;
}

table.table-style-two tr:hover td {
	background-color: #d9f9f0;
}

table.table-style-two td {
	border-width: 1px;
	padding: 8px;
	border-style: solid;
	border-color: #d9f9f0;
	background-color: #ffffff;
}

#topMenu {
	height: 30px; /* 메인 메뉴의 높이 */
	width: 850px; /* 메인 메뉴의 넓이 */
}

#topMenu ul { /* 메인 메뉴 안의 ul을 설정함: 상위메뉴의 ul+하위 메뉴의 ul */
	list-style-type: none; /* 메인 메뉴 안의 ul 내부의 목록 표시를 없애줌 */
	margin: 0px; /* 메인 메뉴 안의 ul의 margin을 없앰 */
	padding: 0px; /* 메인 메뉴 안의 ul의 padding을 없앰 */
}

#topMenu ul li { /* 메인 메뉴 안에 ul 태그 안에 있는 li 태그의 스타일 적용(상위/하위메뉴 모두) */
	color: white; /* 글씨 색을 흰색으로 설정 */
	float: left; /* 왼쪽으로 나열되도록 설정 */
	line-height: 30px; /* 텍스트 한 줄의 높이를 30px로 설정 */
	vertical-align: middle; /* 세로 정렬을 가운데로 설정 */
	text-align: center; /* 텍스트를 가운데로 정렬 */
	position: relative; /* 해당 li 태그 내부의 top/left 포지션 초기화 */
}

.menuLink, .submenuLink { /* 상위 메뉴와 하위 메뉴의 a 태그에 공통으로 설정할 스타일 */
	text-decoration: none; /* a 태그의 꾸밈 효과 제거 */
	display: block; /* a 태그의 클릭 범위를 넓힘 */
	width: 150px; /* 기본 넓이를 150px로 설정 */
	font-size: 12px; /* 폰트 사이즈를 12px로 설정 */
	font-weight: bold; /* 폰트를 굵게 설정 */
	font-family: "Trebuchet MS", Dotum; /* 기본 폰트를 영어/한글 순서대로 설정 */
}

.menuLink { /* 상위 메뉴의 글씨색을 흰색으로 설정 */
	color: white;
}

.topMenuLi:hover .menuLink { /* 상위 메뉴의 li에 마우스오버 되었을 때 스타일 설정 */
	color: black; /* 글씨 색 빨간색 */
	background-color: #6ADCBD; /* 배경색을 밝은 회색으로 설정 */
}

.submenuLink { /* 하위 메뉴의 a 태그 스타일 설정 */
	color: #6ADCBD; /* 글씨 색을 RGB(2D2D2D)로 설정 */
	background-color: white; /* 배경색을 흰색으로 설정 */
	border: solid 1px black; /* 테두리를 설정 */
	margin-top: -1px; /* 위 칸의 하단 테두리와 아래칸의 상단 테두리가 겹쳐지도록 설덩 */
}

.longLink { /* 좀 더 긴 메뉴 스타일 설정 */
	width: 190px; /* 넓이는 190px로 설정 */
}

.submenu { /* 하위 메뉴 스타일 설정 */
	position: absolute; /* html의 flow에 영향을 미치지 않게 absolute 설정 */
	height: 0px; /* 초기 높이는 0px로 설정 */
	overflow: hidden; /* 실 내용이 높이보다 커지면 해당 내용 감춤 */
	transition: height .2s; /* height를 변화 시켰을 때 0.2초간 변화 되도록 설정(기본) */
	-webkit-transition: height .2s;
	/* height를 변화 시켰을 때 0.2초간 변화 되도록 설정(구버전 크롬/사파라ㅣ) */
	-moz-transition: height .2s;
	/* height를 변화 시켰을 때 0.2초간 변화 되도록 설정(구버전 파폭) */
	-o-transition: height .2s;
	/* height를 변화 시켰을 때 0.2초간 변화 되도록 설정(구버전 오페라) */
}

.topMenuLi:hover .submenu { /* 상위 메뉴에 마우스 모버한 경우 그 안의 하위 메뉴 스타일 설정 */
	height: 93px; /* 높이를 93px로 설정 */
}

.submenuLink:hover { /* 하위 메뉴의 a 태그의 마우스 오버 스타일 설정 */
	color: black; /* 글씨색을 빨간색으로 설정 */
	background-color: #FFFFFF; /* 배경을 RGB(DDDDDD)로 설정 */
}

.abox {
	width: 2000px;
	height: 100px;
	background-color: #78797D;
	border: 1px solid #AAA;
}

.thlee {
	color: #000000;
}
</style>

<!-- Required meta tags -->
<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="keywords"
	content="Bootstrap, Parallax, Template, Registration, Landing">
<meta name="viewport"
	content="width=device-width, initial-scale=1, maximum-scale=1">
<meta name="author" content="Grayrids">
<title>Wellfare</title>

<!-- Bootstrap CSS -->
<link rel="stylesheet" href="css/bootstrap.min.css">
<link rel="stylesheet" href="css/font-awesome.min.css">
<link rel="stylesheet" href="css/line-icons.css">
<link rel="stylesheet" href="css/owl.carousel.css">
<link rel="stylesheet" href="css/owl.theme.css">
<link rel="stylesheet" href="css/nivo-lightbox.css">
<link rel="stylesheet" href="css/magnific-popup.css">
<link rel="stylesheet" href="css/slicknav.css">
<link rel="stylesheet" href="css/animate.css">
<link rel="stylesheet" href="css/main.css">
<link rel="stylesheet" href="css/responsive.css">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>


</head>



<%request.setCharacterEncoding("UTF-8"); %>

<jsp:useBean id="gb1" scope= "page" class="DO.check_DO"></jsp:useBean>
<jsp:useBean id="to1" scope="request" class="DO.Patient_DO" />
<jsp:useBean id="datas" scope="request" class="java.util.ArrayList" />
<jsp:useBean id="gb" scope= "page" class="DO.login_DO"></jsp:useBean>
<jsp:useBean id="ab" scope="page" class="bean.Db_connection"></jsp:useBean>
<jsp:setProperty property="*" name="gb"></jsp:setProperty>
<jsp:setProperty property="*" name="gb1"></jsp:setProperty>

<body>


	<div class="abox">
		<nav class="navbar navbar-expand-lg fixed-top scrolling-navbar indigo">
		<div class="container">
			<!-- Brand and toggle get grouped for better mobile display -->
			<div class="navbar-header">
				<a href="main.jsp" class="navbar-brand"><img class="img-fulid"
					src="img/logo.png" alt=""></a>
			</div>
			<div class="collapse navbar-collapse" id="main-navbar">
				<div align="center" style="height: 30px;">
					<nav id="topMenu">
					<ul>
						<li class="topMenuLi"><a class="menuLink" href="#">간호사
								리스트</a>
							<ul class="submenu">
								<li><a class="submenuLink longLink"
									href="control.jsp?action=list">간호사 목록</a></li>
							</ul></li>
						<li>|</li>
						<li class="topMenuLi"><a class="menuLink" href="#">환자리스트</a>
							<ul class="submenu">
								<li><a class="submenuLink longLink"
									href="control.jsp?action=list1">전체 리스트</a></li>
								<li><a class="submenuLink longLink"
									href="control.jsp?action=list2">팀별 리스트</a></li>

							</ul></li>
						<li>|</li>
						<li class="topMenuLi"><a class="menuLink" href="#">환자 추가
						</a>
							<ul class="submenu">
								<li><a class="submenuLink longLink"
									href="insertPatient.jsp">환자 데이터 추가</a></li>
							</ul></li>
						<li>|</li>
						<li class="topMenuLi"><a class="menuLink" href="#">환자
								모니터링 </a>
							<ul class="submenu">
								<li><a class="submenuLink longLink"
									href="control.jsp?action=list3">실시간 모니터링</a></li>
							</ul></li>
					</ul>
					</nav>
				</div>
			</div>
		</div>
		</nav>
	</div>

	<div align="center">
		<br> <br>
		<div class="section-header">
			<h2 class="section-title wow fadeIn" data-wow-duration="1000ms"
				data-wow-delay="0.3s" style="text-align: center;"><%=to1.getName()%>님
				차트
			</h2>
			<hr class="lines wow zoomIn" data-wow-delay="0.3s">
		</div>

		<%
			int id = to1.getId();
			System.out.println(id);

		    //check_DO ob3 = ab.rankDB(id, pass);
		%>	
			

		<form name=delform method=post action=control.jsp>
			<input type=hidden name="ab_id" value="<%=to1.getId()%>">

			<table class="table-style-two" width="700px" height="800px">

				<tr>
					<th colspan="8"
						style="text-align: center; background-color: #78797D; color: white;">개인
						정보
					</td>
				</tr>

				<tr>
					<th style="text-align: center;">번호</th>
					<td style="text-align: center"; ><%=to1.getId()%></td>
					<th style="text-align: center;">이 름</th>
					<td style="text-align: center";><%=to1.getName()%></td>
					<th style="text-align: center;">나이</th>
					<td style="text-align: center";><%=to1.getAge()%></td>

				</tr>

				<tr>
					<th style="text-align: center;">병실</th>
					<td colspan="6" style="text-align: center";><%=to1.getPatient_room()%></td>
				</tr>


				<tr>
					<th colspan="8"
						style="text-align: center; background-color: #78797D; color: white;">Vital
						정보
					</td>
				</tr>

				<tr>
					<th style="text-align: center;">혈압</th>
					<td colspan="6" style="text-align: center";><%=to1.getBlood_pressure()%></td>
				</tr>

				<tr>
					<th style="text-align: center;">체온</th>
					<td colspan="6" style="text-align: center";><%=to1.getBody_temp()%></td>
				</tr>

				<tr>
					<th style="text-align: center;">심박</th>
					<td colspan="6" style="text-align: center";><%=to1.getBpm()%></td>
				</tr>

				<tr>
					<th style="text-align: center;">호흡</th>
					<td colspan="6" style="text-align: center";><%=to1.getRespiration()%></td>
				</tr>

				<tr>
					<th colspan="8"
						style="text-align: center; background-color: #78797D; color: white;">특이
						사항
					</td>
				</tr>

				<tr>
					<th style="text-align: center;">기타</th>
					<td colspan="6" style="text-align: center";><%=to1.getThe_others()%></td>
				</tr>
			</table>
			<br> <span>		
			 <input class="button" type="button"
				value="삭제" onClick="dellcheck()">


			</span>
		</form>
			<form name="upform" action="updatePatient.jsp" method="post">
				<input type=hidden name="id" value="<%=to1.getId()%>">
				<input type=hidden name="name" value="<%=to1.getName()%>">
				<input class="button" type="button" value="업데이트" onClick="upcheck()">
			</form>
			
		
	</div>
	
	
		
<script type="text/javascript">
	var id = '<%=id%>';

	function upcheck() {
		result = confirm("정말로 업데이트 하시겠습니까 ?");

		if (result == true) {
			document.upform.submit();
			} else
				return;
		}
	
	
	function dellcheck(){
		var inputID = prompt('아이디를 입력하세요', '');
		var inputPW = prompt('패스워드를 입력하세요', '');
		document.location.href="control.jsp?action=delete&nid="+inputID+"&npw="+inputPW+"&id="+<%=to1.getId()%>;
	}
	
	function delcheck() {
		result = confirm("정말로 삭제하시겠습니까 ?");

		if (result == true) {
			document.delform.action.value = "delete";
			document.delform.submit();
		} else
			return;
	}

	function check(getId) {
		document.location.href = "updatePatient?getId="+getId;
	}
	
	</script>

</body>
</html>