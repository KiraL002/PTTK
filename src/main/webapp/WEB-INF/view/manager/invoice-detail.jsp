<%@ page pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/view/fragments/header.jspf" %>
<article class="panel invoice-paper">
    <div class="invoice-title">
        <div>
            <p class="section-label">GARAMAN · HÓA ĐƠN SỬA CHỮA</p>
            <h2>Hóa đơn <c:out value="${invoice.code}"/></h2>
        </div>
        <span class="badge">Đã thanh toán</span>
    </div>
    <div class="invoice-meta">
        <p><span>Khách hàng</span><c:out value="${invoice.customer.fullName}"/></p>
        <p><span>Điện thoại</span><c:out value="${invoice.customer.phone}"/></p>
        <p><span>Biển số xe</span><c:out value="${invoice.car.licensePlate}" default="—"/></p>
        <p><span>Loại xe</span><c:out value="${invoice.car.brand}"/> <c:out value="${invoice.car.model}"/></p>
        <p><span>Ngày lập</span>${g:date(invoice.createdDate)}</p>
        <p><span>Ngày thanh toán</span>${g:date(invoice.paymentDate)}</p>
        <p><span>Nhân viên phụ trách</span><c:out value="${invoice.salesStaff.fullName}" default="—"/></p>
        <p><span>Thanh toán</span>${invoice.paymentMethod == 'CASH' ? 'Tiền mặt' : (invoice.paymentMethod == 'BANK_TRANSFER' ? 'Chuyển khoản' : fn:escapeXml(invoice.paymentMethod))}</p>
    </div>
    <p><strong>Yêu cầu sửa chữa:</strong> <c:out value="${invoice.requestDescription}"/></p>
    <h2>Dịch vụ đã thực hiện</h2>
    <div class="table-wrap">
        <table>
            <thead>
                <tr>
                    <th>Dịch vụ</th>
                    <th class="numeric">Số lượng</th>
                    <th class="numeric">Đơn giá (đ)</th>
                    <th class="numeric">Thành tiền (đ)</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="line" items="${invoice.invoiceServices}">
                    <tr>
                        <td><c:out value="${line.service.name}"/><c:if test="${not empty line.technician}"><br><small>Kĩ thuật viên: <c:out value="${line.technician}"/></small></c:if></td>
                        <td class="numeric">${g:quantity(line.quantity)}</td>
                        <td class="numeric">${g:money(line.price)}</td>
                        <td class="numeric">${g:money(line.lineTotal)}</td>
                    </tr>
                </c:forEach>
                <c:if test="${empty invoice.invoiceServices}">
                    <tr>
                        <td colspan="4" class="empty">Không phát sinh dịch vụ.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
    <h2 class="section-space">Phụ tùng đã sử dụng</h2>
    <div class="table-wrap">
        <table>
            <thead>
                <tr>
                    <th>Phụ tùng</th>
                    <th class="numeric">Số lượng</th>
                    <th>Đơn vị</th>
                    <th class="numeric">Đơn giá (đ)</th>
                    <th class="numeric">Thành tiền (đ)</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="line" items="${invoice.invoiceParts}">
                    <tr>
                        <td><c:out value="${line.sparePart.name}"/></td>
                        <td class="numeric">${g:quantity(line.quantity)}</td>
                        <td><c:out value="${line.sparePart.unit}"/></td>
                        <td class="numeric">${g:money(line.price)}</td>
                        <td class="numeric">${g:money(line.lineTotal)}</td>
                    </tr>
                </c:forEach>
                <c:if test="${empty invoice.invoiceParts}">
                    <tr>
                        <td colspan="5" class="empty">Không phát sinh phụ tùng.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
    <div class="invoice-totals">
        <p><span>Tiền dịch vụ</span><strong>${g:money(invoice.serviceTotal)} đ</strong></p>
        <p><span>Tiền phụ tùng</span><strong>${g:money(invoice.partTotal)} đ</strong></p>
        <div class="table-total">
            <span>Tổng tiền thanh toán</span>
            <strong>${g:money(invoice.totalAmount)} đ</strong>
        </div>
    </div>
    <p class="caption section-space">Cảm ơn quý khách đã sử dụng dịch vụ tại GaraMan.</p>
</article>
<c:url var="backInvoices" value="/customer-visits">
    <c:param name="customerId" value="${invoice.customer.id}"/>
    <c:param name="startDate" value="${startDate}"/>
    <c:param name="endDate" value="${endDate}"/>
</c:url>
<div class="actions">
    <a class="button secondary" href="${fn:escapeXml(backInvoices)}">← Quay lại danh sách hóa đơn</a>
    <button type="button" class="button" id="print-invoice">In hóa đơn</button>
</div>
<noscript><p class="notice">Dùng Ctrl+P để mở hộp thoại in của trình duyệt.</p></noscript>
<%@ include file="/WEB-INF/view/fragments/footer.jspf" %>
