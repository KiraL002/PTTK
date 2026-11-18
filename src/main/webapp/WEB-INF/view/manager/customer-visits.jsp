<%@ page pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/view/fragments/header.jspf" %>
<p class="lead">Từ <strong>${g:date(startDate)}</strong> đến <strong>${g:date(endDate)}</strong> · Theo ngày thanh toán.</p>
<section class="panel">
    <h2><c:out value="${customer.fullName}"/> <span class="caption">(<c:out value="${customer.code}"/>)</span></h2>
    <div class="customer-info">
        <p><span>Điện thoại</span><c:out value="${customer.phone}"/></p>
        <p><span>Địa chỉ</span><c:out value="${customer.address}"/></p>
        <p><span>Lần sửa xe đã thanh toán</span>${visitCount}</p>
    </div>
</section>
<section class="panel">
    <h2>Danh sách hóa đơn</h2>
    <div class="table-wrap">
        <table>
            <thead>
                <tr>
                    <th>Mã hóa đơn</th>
                    <th>Ngày thanh toán</th>
                    <th>Biển số xe</th>
                    <th class="numeric">Tổng tiền (đ)</th>
                    <th>Chi tiết</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${invoices}">
                    <tr>
                        <td><c:out value="${item.code}"/></td>
                        <td>${g:date(item.paymentDate)}</td>
                        <td><c:out value="${item.car.licensePlate}" default="—"/></td>
                        <td class="numeric">${g:money(item.totalAmount)}</td>
                        <td>
                            <c:url var="invoiceLink" value="/invoice-detail">
                                <c:param name="invoiceId" value="${item.id}"/>
                                <c:param name="customerId" value="${customer.id}"/>
                                <c:param name="startDate" value="${startDate}"/>
                                <c:param name="endDate" value="${endDate}"/>
                            </c:url>
                            <a class="button secondary small" href="${fn:escapeXml(invoiceLink)}">Xem hóa đơn</a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty invoices}">
                    <tr>
                        <td colspan="5" class="empty">Khách hàng chưa có hóa đơn đã thanh toán trong kỳ.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
    <div class="table-total">
        <span>Tổng doanh thu</span>
        <strong>${g:money(totalRevenue)} đ</strong>
    </div>
</section>
<c:url var="result" value="/statistics-result">
    <c:param name="startDate" value="${startDate}"/>
    <c:param name="endDate" value="${endDate}"/>
</c:url>
<div class="actions">
    <a class="button secondary" href="${fn:escapeXml(result)}">← Quay lại thống kê</a>
</div>
<%@ include file="/WEB-INF/view/fragments/footer.jspf" %>
