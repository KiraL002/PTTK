<%@ page pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/view/fragments/header.jspf" %>
<section class="panel">
    <h2>Yêu cầu chưa thể thực hiện</h2>
    <p>Đường dẫn không hợp lệ, phiên làm việc đã hết hạn hoặc hệ thống đang gặp sự cố. Bạn có thể trở về trang chủ để tiếp tục.</p>
    <a class="button" href="${pageContext.request.contextPath}/home">Về trang chủ</a>
</section>
<%@ include file="/WEB-INF/view/fragments/footer.jspf" %>
