<%@ page pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/view/fragments/header.jspf" %>
<section class="panel login-panel">
    <h2>Chào mừng trở lại</h2>
    <p class="lead">Đăng nhập tài khoản quản lí để xem báo cáo khách hàng và hóa đơn.</p>
    <form method="post" action="${pageContext.request.contextPath}/login" class="login-form">
        <input type="hidden" name="csrf" value="${sessionScope.csrf}">
        <input type="hidden" name="next" value="${fn:escapeXml(next)}">
        <div class="field">
            <label for="username">Tên đăng nhập</label>
            <input
                id="username"
                name="username"
                value="${fn:escapeXml(username)}"
                maxlength="50"
                autocomplete="username"
                required
                autofocus
            >
        </div>
        <div class="field">
            <label for="password">Mật khẩu</label>
            <input id="password" name="password" type="password" maxlength="256" autocomplete="current-password" required>
        </div>
        <button class="button" type="submit">Đăng nhập</button>
    </form>
</section>
<%@ include file="/WEB-INF/view/fragments/footer.jspf" %>
