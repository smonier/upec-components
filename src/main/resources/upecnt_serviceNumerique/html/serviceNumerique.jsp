<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="ui" uri="http://www.jahia.org/tags/uiComponentsLib" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="query" uri="http://www.jahia.org/tags/queryLib" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="s" uri="http://www.jahia.org/tags/search" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>

<jcr:nodeProperty node="${currentNode}" name="jcr:title" var="title"/>
<jcr:nodeProperty node="${currentNode}" name="image" var="image"/>
<jcr:nodeProperty node="${currentNode}" name="description" var="description"/>
<jcr:nodeProperty node="${currentNode}" name="buttonText" var="buttonText"/>
<jcr:nodeProperty node="${currentNode}" name="j:defaultCategory" var="Categories"/>
<jcr:nodeProperty node="${currentNode}" name="j:tagList" var="Tags"/>

<c:set var="myCat" value=""/>
<c:if test="${!empty Categories }">
    <c:forEach items="${Categories}" var="category">
        <c:set var="myCat" value="${myCat} ${category.node.name}"/>
    </c:forEach>
</c:if>
<c:set var="myTags" value=""/>
<c:if test="${!empty Tags }">
    <c:forEach items="${Tags}" var="tag">
        <c:set var="myTags" value="${myTags} ${tag.string}"/>
    </c:forEach>
</c:if>

<c:set var="linkType" value="${currentNode.properties.linkType.string}" />
<c:set var="linkTarget" value="${currentNode.properties.linkTarget.string}" />

<c:choose>
    <c:when test="${linkType eq 'internalLink'}">
        <c:set var="internalLinkNode" value="${currentNode.properties.internalLink.node}"/>
        <c:choose>
            <c:when test="${! empty internalLinkNode}">
                <c:url var="linkUrl" value="${internalLinkNode.url}"/>
            </c:when>
        </c:choose>
    </c:when>
    <c:when test="${linkType eq 'externalLink'}">
        <c:url var="linkUrl" value="${currentNode.properties.externalLink.string}"/>
    </c:when>
    <c:when test="${linkType eq 'self'}">
        <c:url var="linkUrl" value="${currentNode.url}"/>
    </c:when>
    <c:when test="${linkType eq 'iFrame'}">
        <c:url var="linkUrl" value="${url.base}${currentNode.path}.html"/>
    </c:when>
    <c:when test="${linkType eq 'self'}">
        <c:url var="linkUrl" value="${currentNode.url}"/>
    </c:when>
</c:choose>

<div class="card m-2 overlay ${myTags} ${myCat}" style="width: 16rem;height:480px">
    <c:if test="${not empty image}">
        <jahia:addCacheDependency node="${image.node}" />
        <c:url value="${url.files}${image.node.path}" var="imageUrl"/>
        <div class="img-fluid ">
            <a href="<c:url value='${url.base}${currentNode.path}.html'/>">

                <img class="card-img-top" src="${imageUrl}" alt="${title}" width="100%">

            </a>
        </div>
    </c:if>
    <div class="card-body" style="margin-top:-80px">
        <h4 class="card-title">${fn:escapeXml(title.string)}</h4>
        <p class="card-text">${functions:abbreviate(functions:removeHtmlTags(description),200,250,'...')}</p>
        <a href="${linkUrl}" class="mb-3 mr-3 btn btn-primary btn-sm align-self-end" style="position:absolute;bottom:0;right:0" target="${linkTarget}">${buttonText.string}</a>
    </div>
</div>

<!-- End of card -->
<c:if test="${renderContext.editMode}">
    <%--
    As only one child type is defined no need to restrict
    if a new child type is added restriction has to be done
    using 'nodeTypes' attribute
    --%>
    <template:module path="*" />
</c:if>