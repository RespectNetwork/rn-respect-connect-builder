package net.respectnetwork.respectconnect.builder;

import java.io.IOException;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import xdi2.core.ContextNode;
import xdi2.core.Graph;
import xdi2.core.features.linkcontracts.LinkContractTemplate;
import xdi2.core.features.linkcontracts.MetaLinkContract;
import xdi2.core.features.nodetypes.XdiAbstractEntity;
import xdi2.core.impl.memory.MemoryGraphFactory;
import xdi2.core.io.XDIWriterRegistry;
import xdi2.core.io.writers.XDIJSONWriter;
import xdi2.core.xri3.XDI3Segment;

public class BuildMetaLinkContractXDI extends javax.servlet.http.HttpServlet implements javax.servlet.Servlet {

	private static final long serialVersionUID = 1473425736448426130L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		this.doPost(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String linkContractTemplateAddressString = request.getParameter("linkContractTemplateAddress");
		String metaLinkContractAddressString = request.getParameter("metaLinkContractAddress");
		String requestAttributesString = request.getParameter("requestAttributes");

		// set up parameters

		if (linkContractTemplateAddressString == null || linkContractTemplateAddressString.trim().isEmpty()) throw new ServletException("No link contract template address.");
		if (metaLinkContractAddressString == null || linkContractTemplateAddressString.trim().isEmpty()) throw new ServletException("No meta link contract address.");

		XDI3Segment linkContractTemplateAddress = XDI3Segment.create(linkContractTemplateAddressString);
		if (linkContractTemplateAddress == null) throw new ServletException("No link contract template address.");

		XDI3Segment metaLinkContractAddress = XDI3Segment.create(metaLinkContractAddressString);
		if (metaLinkContractAddress == null) throw new ServletException("No meta link contract address.");

		String[] requestAttributesStrings = requestAttributesString.split("\n");
		List<XDI3Segment> requestAttributes = new ArrayList<XDI3Segment> ();

		for (int i=0; i<requestAttributesStrings.length; i++) {

			requestAttributesStrings[i] = requestAttributesStrings[i].trim();
			if (requestAttributesStrings[i].isEmpty()) continue;

			requestAttributes.add(XDI3Segment.create(requestAttributesStrings[i]));
		}

		// create meta link contract XDI

		Graph graph = MemoryGraphFactory.getInstance().openGraph();
		ContextNode linkContractTemplateContextNode = graph.setDeepContextNode(linkContractTemplateAddress);
		ContextNode metaLinkContractContextNode = graph.setDeepContextNode(metaLinkContractAddress);

		LinkContractTemplate linkContractTemplate = LinkContractTemplate.fromXdiEntity(XdiAbstractEntity.fromContextNode(linkContractTemplateContextNode));
		MetaLinkContract metaLinkContract = MetaLinkContract.fromXdiEntity(XdiAbstractEntity.fromContextNode(metaLinkContractContextNode));

		metaLinkContract.setLinkContractTemplate(linkContractTemplate);

		// output it

		Properties parameters = new Properties();
		parameters.setProperty(XDIWriterRegistry.PARAMETER_INNER, "0");
		parameters.setProperty(XDIWriterRegistry.PARAMETER_PRETTY, "1");
		XDIJSONWriter xdiWriter = (XDIJSONWriter) XDIWriterRegistry.forFormat("XDI/JSON", parameters);
		StringWriter buffer = new StringWriter();
		xdiWriter.write(graph, buffer);
		response.setContentType(XDIJSONWriter.MIME_TYPE.getMimeType());
		response.getWriter().write(buffer.getBuffer().toString());
	}   	  	    
}
