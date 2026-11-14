<%@ page pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/view/fragments/header.jspf" %>
<section class="panel">
    <h2>Chọn tiêu chí thống kê</h2>
    <div class="report-option">
        <div>
            <h3>Theo doanh thu</h3>
            <p>Xếp hạng khách hàng theo tổng giá trị hóa đơn đã thanh toán.</p>
        </div>
        <a class="button" href="${pageContext.request.contextPath}/statistics-period">Theo doanh thu →</a>
    </div>
</section>
<div class="actions">
    <a class="button secondary" href="${pageContext.request.contextPath}/reports">← Quay lại báo cáo</a>
</div>
<%@ include file="/WEB-INF/view/fragments/footer.jspf" %>
