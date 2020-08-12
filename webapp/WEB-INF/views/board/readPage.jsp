<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<%@include file="../include/header.jsp"  %>


<form role="form" action="modifyPage" method="post">

	<input type='hidden' name='bno' value="${boardVO.bno}">
	<input type='hidden' name='page' value="${cri.page}">
	<input type='hidden' name='perPageNum' value="${cri.perPageNum}">

</form>

<div class="box-body">
	<div class="form-group">
		<label for="exampleInputEmail1">Title</label>
		<input type ="text" name='title' class="form-control" value="${boardVO.title}"
		readonly="readonly">
	</div>
	<div class="form-group">
		<label for="exampleInputPassword1">Content</label>
		<textarea class="form-control" name="content" rows="3"
		readonly="readonly">${boardVO.content}</textarea>
	</div>
	<div class="form-group">
		<label for="exampleInputEmail1">Writer</label>
		<input type="text" name="writer" class="form-control" value="${boardVO.writer}"
		readonly="readonly">
	</div>
</div>
<!--  /.box body -->

<div class="box-footer">
	<button type="submit" class="btn btn-warning modifyBtn">Modify</button>
	<button type="submit" class="btn btn-danger removeBtn">REMOVE</button>
	<button type="submit" class="btn btn-primary goListBtn">GO LIST</button>
</div>

<script>

$(document).ready(function(){

var formObj = $("form[role='form']");

console.log(formObj);

$(".modifyBtn").on("click", function(){
	formObj.attr("action", "/board/modifyPage");
	formObj.attr("method", "get");
	formObj.submit();
	});
	
$(".removeBtn").on("click", function(){
	formObj.attr("action", "/board/removePage");
	formObj.submit();
});

$(".goListBtn").on("click", function(){
	formObj.attr("method", "get");
	formObj.attr("action", "/board/listPage");
	formObj.submit();
	});

});


</script>

<%@include file="../include/footer.jsp"  %>

