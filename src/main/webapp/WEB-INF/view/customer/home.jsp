<%@ page pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/view/fragments/header.jspf" %>
<section class="welcome">
    <h2>Chăm sóc chiếc xe của bạn</h2>
    <p class="lead">Tra cứu dịch vụ và phụ tùng phù hợp trước khi đến gara. Giá, thông số và thông tin bảo hành được cập nhật tại từng mục.</p>
</section>
<div class="cards">
    <section class="panel module-card">
        <span class="module-number">DÀNH CHO KHÁCH HÀNG</span>
        <h2>Dịch vụ &amp; phụ tùng</h2>
        <p>Tìm theo tên, xem giá và chi tiết dịch vụ hoặc phụ tùng đang cung cấp.</p>
        <a class="button" href="${pageContext.request.contextPath}/search">Tra cứu ngay →</a>
    </section>
    <section class="panel module-card">
        <span class="module-number">DÀNH CHO QUẢN LÍ</span>
        <h2>Báo cáo khách hàng</h2>
        <p>Theo dõi doanh thu theo khách hàng, xem các lần sửa xe và chi tiết hóa đơn.</p>
        <a class="button secondary" href="${pageContext.request.contextPath}/manager">Vào khu vực quản lí →</a>
    </section>
</div>
<%@ include file="/WEB-INF/view/fragments/footer.jspf" %>
