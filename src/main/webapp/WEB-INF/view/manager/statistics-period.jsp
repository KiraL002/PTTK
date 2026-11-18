<%@ page pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/view/fragments/header.jspf" %>
<section class="panel">
    <h2>Khoảng thời gian thanh toán</h2>
    <p class="lead">Thống kê tính cả ngày bắt đầu và ngày kết thúc, chỉ gồm hóa đơn đã thanh toán. Khoảng ngày gợi ý là tháng có hóa đơn thanh toán gần nhất.</p>
    <form class="period-form" method="get" action="${pageContext.request.contextPath}/statistics-result">
        <div class="form-row">
            <div class="field">
                <label for="startDate">Từ ngày</label>
                <div class="date-field">
                    <input id="startDate" name="startDate" type="text" placeholder="dd/mm/yyyy"
                           value="${fn:escapeXml(g:dateInput(startDate))}" required>
                    <span class="date-picker" hidden>
                        <button class="button secondary" type="button" aria-label="Mở lịch chọn ngày bắt đầu">Lịch</button>
                        <input type="date" min="1900-01-01" max="9998-12-31" tabindex="-1" aria-hidden="true">
                    </span>
                </div>
            </div>
            <div class="field">
                <label for="endDate">Đến ngày</label>
                <div class="date-field">
                    <input id="endDate" name="endDate" type="text" placeholder="dd/mm/yyyy"
                           value="${fn:escapeXml(g:dateInput(endDate))}" required>
                    <span class="date-picker" hidden>
                        <button class="button secondary" type="button" aria-label="Mở lịch chọn ngày kết thúc">Lịch</button>
                        <input type="date" min="1900-01-01" max="9998-12-31" tabindex="-1" aria-hidden="true">
                    </span>
                </div>
            </div>
        </div>
        <div class="actions">
            <button type="submit" class="button">Xem thống kê</button>
            <a class="button secondary" href="${pageContext.request.contextPath}/customer-statistics">← Quay lại</a>
        </div>
    </form>
</section>
<%@ include file="/WEB-INF/view/fragments/footer.jspf" %>
