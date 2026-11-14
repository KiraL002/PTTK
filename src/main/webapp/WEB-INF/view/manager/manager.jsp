<%@ page pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/view/fragments/header.jspf" %>
<section class="welcome">
    <h2>Xin chào, <c:out value="${sessionScope.manager.fullName}"/>.</h2>
    <p class="lead">Xem doanh thu và lịch sử sửa xe của khách hàng tại gara.</p>
</section>
<section class="panel">
    <h2>Báo cáo và thống kê</h2>
    <p>Theo dõi khách hàng theo doanh thu trong khoảng thời gian được chọn.</p>
    <a class="button" href="${pageContext.request.contextPath}/reports">Xem báo cáo →</a>
</section>
<%@ include file="/WEB-INF/view/fragments/footer.jspf" %>
