<%@ page pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/view/fragments/header.jspf" %>
<section class="panel">
    <h2>Khoảng thời gian thanh toán</h2>
    <p class="lead">Thống kê tính cả ngày bắt đầu và ngày kết thúc, chỉ gồm hóa đơn đã thanh toán. Khoảng ngày gợi ý là tháng có hóa đơn thanh toán gần nhất.</p>
    <form class="period-form" method="get" action="${pageContext.request.contextPath}/statistics-result">
        <div class="form-row">
            <div class="field">
                <label for="startDate">Từ ngày</label>
                <input
                    id="startDate"
                    name="startDate"
                    type="date"
                    min="1900-01-01"
                    max="9998-12-31"
                    value="${fn:escapeXml(startDate)}"
                    required
                >
            </div>
            <div class="field">
                <label for="endDate">Đến ngày</label>
                <input id="endDate" name="endDate" type="date" min="1900-01-01" max="9998-12-31" value="${fn:escapeXml(endDate)}" required>
            </div>
        </div>
        <div class="actions">
            <button type="submit" class="button">Xem thống kê</button>
            <a class="button secondary" href="${pageContext.request.contextPath}/customer-statistics">← Quay lại</a>
        </div>
    </form>
</section>
<%@ include file="/WEB-INF/view/fragments/footer.jspf" %>
