<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<%@include file="../include/header.jsp"  %>




<form role="form" action="modifyPage" method="post">

	<input type='hidden' name='bno' value="${boardVO.bno}">
	<input type='hidden' name='page' value="${cri.page}">
	<input type='hidden' name='perPageNum' value="${cri.perPageNum}">
	<input type='hidden' name='searchType' value="${cri.searchType}">
	<input type='hidden' name='keyword' value="${cri.keyword}">

</form>

<div class="box-body">
	<div class="form-group">
		<label for="exampleInputEmail1">제목</label>
		<input type ="text" name='title' class="form-control" value="${boardVO.title}"
		readonly="readonly">
	</div>
	<div class="form-group">
		<label for="exampleInputPassword1">내용</label>
		<textarea class="form-control" name="content" rows="8"
		readonly="readonly">${boardVO.content}</textarea>
	</div>
	<div class="form-group">
		<label for="exampleInputEmail1">작성자</label>
		<input type="text" name="writer" class="form-control" value="${boardVO.writer}"
		readonly="readonly">
	</div>
</div>
<!--  /.box body -->

<div class="box-footer">
	<button type="submit" class="btn btn-warning modifyBtn">수정</button>
	<button type="submit" class="btn btn-danger removeBtn">삭제</button>
	<button type="submit" class="btn btn-primary goListBtn">목록</button>
</div>



<!-- 댓글 작성 부분  -->

<div class="row">
	<div class="col-md-12">
	
		<div class="box box-success">
			<h3 class="box-title">댓글 작성하기</h3>
		</div>
		<div class="box-body">
			<label for="newReplyWriter">작성자</label>
				<input class="form-control" type="text" placeholder="User ID" id="newReplyWriter">
				<label for="newReplyText">내용</label>
				<input class="form-control" type="text" placeholder="Reply Text" id="newReplyText">
		</div>
		
		<!--  /.box-body -->
		<div class="box-footer">
		<button type="submit" class="btn btn-primary" id="replyAddBtn">등록</button>
		</div>
	</div>

</div>


<!-- the time line -->

<ul class="timeline">
	<!-- timeline time label -->
	<li class="time-label" id="repliesDiv"><span class="bg-green" >댓글 목록</span></li>
</ul>

<div class="text-center">
	<ul id="pagination" class="pagination pagination-sm no-margin">
	</ul>
</div>

<!--  Modal -->
<!-- Modal -->
<div id="modifyModal" class="modal modal-primary fade" role="dialog">
  <div class="modal-dialog">
    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title"></h4>
      </div>
      <div class="modal-body" data-rno>
        <p><input type="text" id="replytext" class="form-control"></p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-info" id="replyModBtn">수정</button>
        <button type="button" class="btn btn-danger" id="replyDelBtn">삭제</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>      
	
 
<!--  handlebars 사용 댓글 목록 -->
<script id="template" type="text/x-handlebars-template">
{{#each .}}
	<li class="replyLi" data-rno={{rno}}>
<i class="fa fa-comments bg-blue"></i>
 <div class="timeline-item" >
	<span class="time">
    	<i class="fa fa-clock-o"></i>{{prettifyDate regdate}}
	</span>
	<h3 class="timeline-header"><strong>{{rno}}</strong> -{{replyer}}</h3>
	<div class="timeline-body">{{replytext}}</div>
	<div class="timeline-footer">
	<a class="btn btn-primary btn-xs" data-toggle="modal" data-target="#modifyModal">수정</a>
	</div>
  </div>
</li>
{{/each}}

</script>

<!-- prettifyDate의 js -->
<script>

Handlebars.registerHelper("prettifyDate", function(timeValue) {
	var dateObj = new Date(timeValue);
	var year = dateObj.getFullYear();
	var month = dateObj.getMonth()+1;
	var date = dateObj.getDate();

	return year+"/"+month+"/"+date;
});

var printData = function( replyArr, target, templateObject) {

	var template = Handlebars.compile(templateObject.html());

	var html = template(replyArr);
	$(".replyLi").remove();
	target.after(html);
}

var bno = ${boardVO.bno};
var replyPage = 1;

function getPage(pageInfo){

	console.log("getPage............." , pageInfo);

	console.log($("#modifyModal"));

	$.getJSON(pageInfo, function(data){
	printData(data.list, $("#repliesDiv"), $("#template"));
	printPaging(data.pageMaker, $(".pagination"));
	console.log("getJSON...........end");
	$("#modifyModal").modal("hide");
	});

	}

var printPaging = function(pageMaker, target) {

	var str = "";

	if(pageMaker.prev) {
		str+= "<li><a href='"+(pageMaker.startPage-1)+"'> << </a></li>";
		}

	for(var i=pageMaker.startPage, len=pageMaker.endPage; i<= len; i++) {
		var strClass = pageMaker.cri.page == i?'class=active':'';
		str += "<li "+strClass+"><a href='"+i+"'>"+i+"</a></li>";
		}
	if(pageMaker.next) {
		str += "<li><a href='"+(pageMaker.endPage + 1)+"'> >> </a></li>";
		}

	target.html(str);
};

//댓글 목록의 이벤트처리 
$("#repliesDiv").on("click", function() {
	if($(".timeline li").size() > 1){
		return; 
		}
	getPage("/replies/" + bno + "/1");
	
});

//댓글 페이징의 이벤트처리
$(".pagination").on("click", "li a", function(event){

	event.preventDefault();

	replyPage = $(this).attr("href");

	getPage("/replies/" + bno + "/" + replyPage);
	
});

//등록버튼 이벤트처리

$("#replyAddBtn").on("click",function(){
		 
	 var replyerObj = $("#newReplyWriter");
	 var replytextObj = $("#newReplyText");
	 var replyer = replyerObj.val();
	 var replytext = replytextObj.val();

	$.ajax({
		type:'post',
		url:'/replies/',
		headers: {
			"Content-Type": "application/json",
			"X-HTTP-Method-Override": "POST" },
		dataType:'text' ,
		data: JSON.stringify({bno:bno, replyer:replyer, replytext:replytext}),
		success:function(result) {
			console.log("result: " + result);
			if(result == 'SUCCESS'){
				alert("등록 되었습니다.");
				replyPage=1;
				getPage("/replies/" + bno + "/" + replyPage);
				replyerObj.val("");
				replytextObj.val("");
				}
			}});
});

//댓글 수정 인터페이스 모달창이 뜨며 댓글번호(modal-title -> data-rno)와 textArea에 기존 댓글 텍스트 표시 
$(".timeline").on("click", ".replyLi", function(event) {

	var reply = $(this);

	$("#replytext").val(reply.find('.timeline-body').text());
	$(".modal-title").html(reply.attr("data-rno"));
	
});

//댓글 수정의 이벤트처리

$("#replyModBtn").on("click", function() {

	var rno = $(".modal-title").html();
	var replytext = $("#replytext").val();

	$.ajax({
		type:'put',
			url:'/replies/'+ rno,
			headers: {
					"Content-Type": "application/json",
					"X-HTTP-Method-Override": "PUT" },
			data:JSON.stringify({replytext:replytext}),
			dataType:'text',
			success:function(result) {
				console.log("result:" + result);
				if(result == 'SUCCESS'){
					alert("수정 되었습니다.");
					getPage("/replies/" + bno + "/" + replyPage);
					}
				}});
});

$("#replyDelBtn").on("click",function(){

	var rno = $(".modal-title").html();
	var replytext = $("#replytext").val();

	$.ajax({
		type:'delete',
		url : '/replies/' + rno,
		header : {
				"Content-Type":"application/json",
				"X-HTTP-Method-Override": "DELETE" },
		dataType:'text',
		success:function(result) {
			 console.log("result:" + result);
			 	if(result == 'SUCCESS'){
				 	alert("삭제 되었습니다.");
				 	getPage("/replies/" + bno + "/" + replyPage);
			 	}
       }});
});


</script>

<script>

$(document).ready(function(){

var formObj = $("form[role='form']");

console.log(formObj);

$(".modifyBtn").on("click", function(){
	formObj.attr("action", "/sboard/modifyPage");
	formObj.attr("method", "get");
	formObj.submit();
	});
	
$(".removeBtn").on("click", function(){
	formObj.attr("action", "/sboard/removePage");
	formObj.submit();
});

$(".goListBtn").on("click", function(){
	formObj.attr("method", "get");
	formObj.attr("action", "/sboard/list");
	formObj.submit();
	});

});


</script>

<%@include file="../include/footer.jsp"  %>

