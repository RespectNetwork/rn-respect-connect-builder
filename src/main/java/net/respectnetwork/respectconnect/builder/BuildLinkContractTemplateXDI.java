package net.respectnetwork.respectconnect.builder;

import java.io.IOException;
import java.io.StringWriter;
import java.security.GeneralSecurityException;
import java.security.KeyFactory;
import java.security.PrivateKey;
import java.security.interfaces.RSAKey;
import java.security.spec.PKCS8EncodedKeySpec;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base64;

import xdi2.core.ContextNode;
import xdi2.core.constants.XDILinkContractConstants;
import xdi2.core.features.linkcontracts.LinkContract;
import xdi2.core.features.linkcontracts.policy.PolicyAnd;
import xdi2.core.features.linkcontracts.policy.PolicyRoot;
import xdi2.core.features.linkcontracts.policy.PolicyUtil;
import xdi2.core.features.nodetypes.XdiAbstractEntity;
import xdi2.core.features.signatures.KeyPairSignature;
import xdi2.core.features.signatures.Signatures;
import xdi2.core.impl.memory.MemoryGraphFactory;
import xdi2.core.io.XDIWriterRegistry;
import xdi2.core.io.writers.XDIJSONWriter;
import xdi2.core.xri3.XDI3Segment;
import xdi2.core.xri3.XDI3Statement;

public class BuildLinkContractTemplateXDI extends javax.servlet.http.HttpServlet implements javax.servlet.Servlet {

	private static final long serialVersionUID = -2033109040103002340L;

	public static final XDI3Segment TO_PEER_ROOT_XRI = XDI3Segment.create("{$to}");
	public static final XDI3Segment MESSAGE_TYPE = XDI3Segment.create("$connect[$v]#0$xdi[$v]#1$msg");
	public static final XDI3Segment OPERATION_XRI = XDI3Segment.create("$set{$do}");

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		this.doPost(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String requestingPartyString = request.getParameter("requestingParty");
		String linkContractTemplateAddressString = request.getParameter("linkContractTemplateAddress");
		String privateKeyString = request.getParameter("privateKey");
		String requestCloudNameString = request.getParameter("requestCloudName");
		String requestAttributesString = request.getParameter("requestAttributes");

		// set up parameters

		XDI3Segment requestingParty = XDI3Segment.create(requestingPartyString);

		XDI3Segment linkContractTemplateAddress = XDI3Segment.create(linkContractTemplateAddressString);

		boolean requestCloudName = "on".equals(requestCloudNameString);

		String[] requestAttributesStrings = requestAttributesString.split("\n");
		List<XDI3Segment> requestAttributes = new ArrayList<XDI3Segment> ();

		for (int i=0; i<requestAttributesStrings.length; i++) {

			requestAttributesStrings[i] = requestAttributesStrings[i].trim();
			if (requestAttributesStrings[i].isEmpty()) continue;

			requestAttributes.add(XDI3Segment.create(requestAttributesStrings[i]));
		}

		PrivateKey privateKey;		

		try {

			PKCS8EncodedKeySpec keySpec = new PKCS8EncodedKeySpec(Base64.decodeBase64(privateKeyString));
			KeyFactory keyFactory = KeyFactory.getInstance("RSA");
			privateKey = keyFactory.generatePrivate(keySpec);
		} catch (GeneralSecurityException ex) {

			throw new ServletException(ex.getMessage(), ex);
		}

		// create link contract template XDI

		ContextNode linkContractTemplateContextNode = MemoryGraphFactory.getInstance().openGraph().setDeepContextNode(linkContractTemplateAddress);

		LinkContract linkContract = LinkContract.fromXdiEntity(XdiAbstractEntity.fromContextNode(linkContractTemplateContextNode));

		PolicyRoot policyRoot = linkContract.getPolicyRoot(true);
		PolicyAnd policyAnd = policyRoot.createAndPolicy(true);

		PolicyUtil.createSenderIsOperator(policyAnd, requestingParty);
		PolicyUtil.createSignatureValidOperator(policyAnd);

		for (XDI3Segment requestAttribute : requestAttributes) linkContract.setPermissionTargetAddress(XDILinkContractConstants.XRI_S_GET, requestAttribute);

		if (requestCloudName) linkContract.setPermissionTargetStatement(XDILinkContractConstants.XRI_S_GET, XDI3Statement.create("{$to}/$is$ref/{}"));

		try {

			((KeyPairSignature) Signatures.setSignature(linkContract.getContextNode(), "sha", 256, "rsa", ((RSAKey) privateKey).getModulus().bitLength())).sign(privateKey);
		} catch (GeneralSecurityException ex) {

			throw new ServletException(ex.getMessage(), ex);
		}

		// output it

		Properties parameters = new Properties();
		parameters.setProperty(XDIWriterRegistry.PARAMETER_INNER, "1");
		parameters.setProperty(XDIWriterRegistry.PARAMETER_PRETTY, "1");
		XDIJSONWriter xdiWriter = (XDIJSONWriter) XDIWriterRegistry.forFormat("XDI/JSON", parameters);
		StringWriter buffer = new StringWriter();
		xdiWriter.write(linkContract.getContextNode().getGraph(), buffer);
		response.setContentType(XDIJSONWriter.MIME_TYPE.getMimeType());
		response.getWriter().write(buffer.getBuffer().toString());
	}   	  	    
}
