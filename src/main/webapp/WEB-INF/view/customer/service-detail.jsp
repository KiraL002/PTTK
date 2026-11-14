<%@ page pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/view/fragments/header.jspf" %>
<c:if test="${not empty service}">
    <section class="panel">
        <div class="detail-head">
            <h2 class="detail-title"><c:out value="${service.name}"/></h2>
            <span class="badge">Đang cung cấp</span>
        </div>
        <dl class="detail-grid">
            <dt>Mã dịch vụ</dt>
            <dd><c:out value="${service.code}"/></dd>
            <dt>Giá dịch vụ</dt>
            <dd>${g:money(service.price)} ₫</dd>
            <dt>Thời gian dự kiến</dt>
            <dd>${empty service.duration ? '—' : service.duration} giờ</dd>
            <dt>Nhóm dịch vụ</dt>
            <dd><c:out value="${service.category}"/></dd>
            <dt>Xe áp dụng</dt>
            <dd><c:out value="${service.applicableCar}"/></dd>
            <dt>Bảo hành</dt>
            <dd>${service.warranty} tháng</dd>
            <dt>Mô tả</dt>
            <dd><c:out value="${service.description}"/></dd>
        </dl>
    </section>
    <section class="panel">
        <h2>Phụ tùng sử dụng tham khảo</h2>
        <p class="caption">Phụ tùng được tính theo số lượng sử dụng thực tế trên hóa đơn.</p>
        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th>Tên phụ tùng</th>
                        <th>Số lượng</th>
                        <th>Đơn vị</th>
                        <th class="money">Giá bán hiện tại</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${service.serviceParts}">
                        <tr>
                            <td><c:out value="${item.sparePart.name}"/></td>
                            <td>${g:quantity(item.quantity)}</td>
                            <td><c:out value="${item.sparePart.unit}"/></td>
                            <td class="money">${g:money(item.sparePart.sellingPrice)} ₫</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty service.serviceParts}">
                        <tr>
                            <td colspan="4" class="empty">Chưa có phụ tùng đi kèm.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </section>
</c:if>
<c:url var="back" value="/search">
    <c:if test="${not empty keyword}">
        <c:param name="keyword" value="${keyword}"/>
    </c:if>
</c:url>
<div class="actions">
    <a class="button secondary" href="${fn:escapeXml(back)}">← Quay lại kết quả</a>
    <a class="button secondary" href="${pageContext.request.contextPath}/search">Tìm kiếm mới</a>
</div>
<%@ include file="/WEB-INF/view/fragments/footer.jspf" %>
