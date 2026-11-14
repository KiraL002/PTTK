<%@ page pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/view/fragments/header.jspf" %>
<section class="panel">
    <h2>Báo cáo khách hàng</h2>
    <p class="lead">Tổng hợp doanh thu, số lần sửa xe và tra cứu hóa đơn của từng khách hàng.</p>
    <a class="button" href="${pageContext.request.contextPath}/customer-statistics">Thống kê khách hàng →</a>
</section>
<div class="actions">
    <a class="button secondary" href="${pageContext.request.contextPath}/manager">← Về trang quản lí</a>
</div>
<%@ include file="/WEB-INF/view/fragments/footer.jspf" %>
