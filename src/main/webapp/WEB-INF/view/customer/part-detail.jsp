<%@ page pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/view/fragments/header.jspf" %>
<c:if test="${not empty sparePart}">
    <section class="panel">
        <div class="detail-head">
            <h2 class="detail-title"><c:out value="${sparePart.name}"/></h2>
            <span class="badge ${sparePart.inStock ? '' : 'neutral'}">${sparePart.inStock ? 'Còn hàng' : 'Tạm hết hàng'}</span>
        </div>
        <dl class="detail-grid">
            <dt>Mã phụ tùng</dt>
            <dd><c:out value="${sparePart.code}"/></dd>
            <dt>Giá bán</dt>
            <dd>${g:money(sparePart.sellingPrice)} đ/<c:out value="${sparePart.unit}"/></dd>
            <dt>Tồn kho</dt>
            <dd>${g:quantity(sparePart.stockQty)} <c:out value="${sparePart.unit}"/></dd>
            <dt>Thông số kĩ thuật</dt>
            <dd><c:out value="${sparePart.specification}"/></dd>
            <dt>Xe áp dụng</dt>
            <dd><c:out value="${sparePart.applicableCar}"/></dd>
            <dt>Bảo hành</dt>
            <dd>${sparePart.warranty} tháng</dd>
            <dt>Mô tả</dt>
            <dd><c:out value="${sparePart.description}"/></dd>
        </dl>
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
