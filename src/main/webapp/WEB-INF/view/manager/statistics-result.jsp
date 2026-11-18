<%@ page pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/view/fragments/header.jspf" %>
<p class="lead">Từ <strong>${g:date(startDate)}</strong> đến <strong>${g:date(endDate)}</strong> · Theo ngày thanh toán.</p>
<div class="summary-row">
    <div class="summary-item">
        <span>Khách hàng</span>
        <strong>${customerCount}</strong>
    </div>
    <div class="summary-item">
        <span>Lần sửa xe đã thanh toán</span>
        <strong>${totalVisits}</strong>
    </div>
    <div class="summary-item">
        <span>Tổng doanh thu</span>
        <strong>${g:money(totalRevenue)} đ</strong>
    </div>
</div>
<section class="panel">
    <h2>Khách hàng theo doanh thu giảm dần</h2>
    <div class="table-wrap">
        <table>
            <thead>
                <tr>
                    <th class="numeric">STT</th>
                    <th>Mã KH</th>
                    <th>Họ và tên</th>
                    <th>Điện thoại</th>
                    <th class="numeric">Số lần</th>
                    <th class="numeric">Doanh thu (đ)</th>
                    <th>Chi tiết</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${statistics}" varStatus="row">
                    <tr>
                        <td class="numeric">${row.count}</td>
                        <td><c:out value="${item.code}"/></td>
                        <td><c:out value="${item.fullName}"/></td>
                        <td><c:out value="${item.phone}"/></td>
                        <td class="numeric">${g:quantity(item.visitCount)}</td>
                        <td class="numeric">${g:money(item.totalRevenue)}</td>
                        <td>
                            <c:url var="visits" value="/customer-visits">
                                <c:param name="customerId" value="${item.id}"/>
                                <c:param name="startDate" value="${startDate}"/>
                                <c:param name="endDate" value="${endDate}"/>
                            </c:url>
                            <a class="button secondary small" href="${fn:escapeXml(visits)}">Các lần sửa xe</a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty statistics}">
                    <tr>
                        <td colspan="7" class="empty">Không có hóa đơn đã thanh toán trong khoảng thời gian này.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</section>
<div class="actions">
    <a class="button secondary" href="${pageContext.request.contextPath}/statistics-period">← Đổi khoảng thời gian</a>
    <a class="button secondary" href="${pageContext.request.contextPath}/manager">Về trang quản lí</a>
</div>
<%@ include file="/WEB-INF/view/fragments/footer.jspf" %>
