<%@ page pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/view/fragments/header.jspf" %>
<section class="panel">
    <form method="get" action="${pageContext.request.contextPath}/search" class="search-form">
        <div class="field">
            <label for="keyword">Tên dịch vụ hoặc phụ tùng</label>
            <div class="search-controls">
                <input
                    id="keyword"
                    name="keyword"
                    maxlength="100"
                    value="${fn:escapeXml(keyword)}"
                    placeholder="Ví dụ: sơn phủ gầm, lọc nhớt, dầu máy…"
                    aria-describedby="search-hint"
                    required
                >
                <button type="submit" class="button">Tìm kiếm</button>
            </div>
            <span class="hint" id="search-hint">Có thể tìm bằng tiếng Việt có dấu hoặc không dấu.</span>
        </div>
    </form>
</section>
<c:choose>
    <c:when test="${searched}">
        <p class="lead">Kết quả cho “<strong><c:out value="${keyword}"/></strong>”: ${serviceCount} dịch vụ, ${partCount} phụ tùng.</p>
        <section class="panel">
            <h2>Dịch vụ <span class="caption">(${serviceCount})</span></h2>
            <div class="table-wrap">
                <table>
                    <thead>
                        <tr>
                            <th>Mã</th>
                            <th>Tên dịch vụ</th>
                            <th class="numeric">Giá dịch vụ (đ)</th>
                            <th class="numeric">Thời gian (giờ)</th>
                            <th>Chi tiết</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${services}">
                            <tr>
                                <td><c:out value="${item.code}"/></td>
                                <td><c:out value="${item.name}"/></td>
                                <td class="numeric">${g:money(item.price)}</td>
                                <td class="numeric">${empty item.duration ? '—' : g:quantity(item.duration)}</td>
                                <td>
                                    <c:url var="detail" value="/service-detail">
                                        <c:param name="serviceId" value="${item.id}"/>
                                        <c:param name="keyword" value="${keyword}"/>
                                    </c:url>
                                    <a class="button secondary small" href="${fn:escapeXml(detail)}">Xem chi tiết</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty services}">
                            <tr>
                                <td colspan="5" class="empty">Không có dịch vụ phù hợp.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </section>
        <section class="panel">
            <h2>Phụ tùng <span class="caption">(${partCount})</span></h2>
            <div class="table-wrap">
                <table>
                    <thead>
                        <tr>
                            <th>Mã</th>
                            <th>Tên phụ tùng</th>
                            <th class="numeric">Giá bán (đ)</th>
                            <th>Đơn vị</th>
                            <th>Tình trạng</th>
                            <th>Chi tiết</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${spareParts}">
                            <tr>
                                <td><c:out value="${item.code}"/></td>
                                <td><c:out value="${item.name}"/></td>
                                <td class="numeric">${g:money(item.sellingPrice)}</td>
                                <td><c:out value="${item.unit}"/></td>
                                <td><span class="badge ${item.inStock ? '' : 'neutral'}">${item.inStock ? 'Còn hàng' : 'Tạm hết hàng'}</span></td>
                                <td>
                                    <c:url var="detail" value="/part-detail">
                                        <c:param name="partId" value="${item.id}"/>
                                        <c:param name="keyword" value="${keyword}"/>
                                    </c:url>
                                    <a class="button secondary small" href="${fn:escapeXml(detail)}">Xem chi tiết</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty spareParts}">
                            <tr>
                                <td colspan="6" class="empty">Không có phụ tùng phù hợp.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </section>
    </c:when>
    <c:otherwise>
        <div class="panel empty">
            Nhập tên dịch vụ hoặc phụ tùng để bắt đầu tra cứu.
        </div>
    </c:otherwise>
</c:choose>
<%@ include file="/WEB-INF/view/fragments/footer.jspf" %>
