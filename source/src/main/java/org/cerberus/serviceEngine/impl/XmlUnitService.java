/*
 * Cerberus  Copyright (C) 2013  vertigo17
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
 *
 * This file is part of Cerberus.
 *
 * Cerberus is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Cerberus is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Cerberus.  If not, see <http://www.gnu.org/licenses/>.
 */
package org.cerberus.serviceEngine.impl;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.logging.Level;
import java.util.regex.Pattern;

import javax.annotation.PostConstruct;

import org.apache.log4j.Logger;
import org.cerberus.entity.ExecutionSOAPResponse;
import org.cerberus.entity.TestCaseExecution;
import org.cerberus.serviceEngine.IXmlUnitService;
import org.cerberus.serviceEngine.impl.diff.Differences;
import org.cerberus.serviceEngine.impl.diff.DifferencesException;
import org.cerberus.serviceEngine.impl.input.AInputTranslator;
import org.cerberus.serviceEngine.impl.input.InputTranslator;
import org.cerberus.serviceEngine.impl.input.InputTranslatorException;
import org.cerberus.serviceEngine.impl.input.InputTranslatorManager;
import org.cerberus.serviceEngine.impl.input.InputTranslatorUtil;
import org.cerberus.util.XmlUtil;
import org.cerberus.util.XmlUtilException;
import org.custommonkey.xmlunit.DetailedDiff;
import org.custommonkey.xmlunit.Difference;
import org.custommonkey.xmlunit.XMLUnit;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

/**
 *
 * @author bcivel
 */
@Service
public class XmlUnitService implements IXmlUnitService {

	/** The associated {@link Logger} to this class */
	private static final Logger LOG = Logger.getLogger(XmlUnitService.class);

	/** Difference value for null XPath */
	public static final String NULL_XPATH = "null";

	/** The default value for the getFromXML action */
	public static final String DEFAULT_GET_FROM_XML_VALUE = "";

	@Autowired
	private ExecutionSOAPResponse executionSOAPResponse;

	/** Prefixed input handling */
	private InputTranslatorManager<Document> inputTranslator;

	@PostConstruct
	private void init() {
		initInputTranslator();
		initXMLUnitProperties();
	}

	/**
	 * Initializes {@link #inputTranslator} by two {@link InputTranslator}
	 * <ul>
	 * <li>One for handle the <code>url</code> prefix</li>
	 * <li>One for handle without prefix</li>
	 * </ul>
	 */
	private void initInputTranslator() {
		inputTranslator = new InputTranslatorManager<Document>();
		// Add handling on the "url" prefix, to get URL input
		inputTranslator.addTranslator(new AInputTranslator<Document>("url") {
			@Override
			public Document translate(String input) throws InputTranslatorException {
				try {
					URL urlInput = new URL(InputTranslatorUtil.getValue(input));
					return XmlUtil.fromURL(urlInput);
				} catch (MalformedURLException e) {
					throw new InputTranslatorException(e);
				} catch (XmlUtilException e) {
					throw new InputTranslatorException(e);
				}
			}
		});
		// Add handling for raw XML input
		inputTranslator.addTranslator(new AInputTranslator<Document>(null) {
			@Override
			public Document translate(String input) throws InputTranslatorException {
				try {
					return XmlUtil.fromString(input);
				} catch (XmlUtilException e) {
					throw new InputTranslatorException(e);
				}
			}
		});
	}

	/**
	 * Initializes {@link XMLUnit} properties
	 */
	private void initXMLUnitProperties() {
		XMLUnit.setIgnoreComments(true);
		XMLUnit.setIgnoreWhitespace(true);
		XMLUnit.setIgnoreDiffBetweenTextAndCDATA(true);
		XMLUnit.setCompareUnmatched(false);
	}

	@Override
	public boolean isElementPresent(TestCaseExecution tCExecution, String xpath) {
		if (xpath == null) {
			LOG.warn("Null argument");
			return false;
		}

		try {
			return XmlUtil.evaluate(executionSOAPResponse.getExecutionSOAPResponse(tCExecution.getExecutionUUID()), xpath).getLength() != 0;
		} catch (XmlUtilException e) {
			LOG.warn("Unable to check if element is present", e);
		}

		return false;
	}

	@Override
	public boolean isSimilarTree(TestCaseExecution tCExecution, String xpath, String tree) {
		if (xpath == null || tree == null) {
			LOG.warn("Null argument");
			return false;
		}

		try {
			NodeList candidates = XmlUtil.evaluate(executionSOAPResponse.getExecutionSOAPResponse(tCExecution.getExecutionUUID()), xpath);
			for (Node candidate : new XmlUtil.IterableNodeList(candidates)) {
				boolean found = true;
				for (org.cerberus.serviceEngine.impl.diff.Difference difference : Differences.fromString(getDifferencesFromXml(XmlUtil.toString(candidate), tree))) {
					if (!difference.getDiff().endsWith("/text()[1]")) {
						found = false;
					}
				}

				if (found) {
					return true;
				}
			}
		} catch (XmlUtilException e) {
			LOG.warn("Unable to check similar tree", e);
		} catch (DifferencesException e) {
			LOG.warn("Unable to check similar tree", e);
		}

		return false;
	}

	@Override
	public String getFromXml(String uuid, String url, String xpath) {
		if (uuid == null || xpath == null) {
			LOG.warn("Null argument");
			return DEFAULT_GET_FROM_XML_VALUE;
		}

		try {
			Document document = url == null ? XmlUtil.fromString(executionSOAPResponse.getExecutionSOAPResponse(uuid)) : XmlUtil.fromURL(new URL(url));
			NodeList candidates = XmlUtil.evaluate(document, xpath + "/text()");
			// Not that in case of multiple values then send the first one
			return candidates != null && candidates.getLength() > 0 ? candidates.item(0).getNodeValue() : DEFAULT_GET_FROM_XML_VALUE;
		} catch (XmlUtilException e) {
			LOG.warn("Unable to get from xml", e);
		} catch (MalformedURLException e) {
			LOG.warn("Unable to get from xml", e);
		}

		return DEFAULT_GET_FROM_XML_VALUE;
	}

	@Override
	public String getDifferencesFromXml(String left, String right) {
		try {
			// Gets the detailed diff between left and right argument
			Document leftDocument = inputTranslator.translate(left);
			Document rightDocument = inputTranslator.translate(right);
			DetailedDiff diffs = new DetailedDiff(XMLUnit.compareXML(leftDocument, rightDocument));

			// Creates the result structure which will contain difference list
			Differences resultDiff = new Differences();

			// Add each difference to our result structure
			for (Object diff : diffs.getAllDifferences()) {
				if (!(diff instanceof Difference)) {
					LOG.warn("Unable to handle no XMLUnit Difference " + diff);
					continue;
				}
				Difference wellTypedDiff = (Difference) diff;
				String xPathLocation = wellTypedDiff.getControlNodeDetail().getXpathLocation();
				// Null XPath location means additional data from the right
				// structure.
				// Then we retrieve XPath from the right structure.
				if (xPathLocation == null) {
					xPathLocation = wellTypedDiff.getTestNodeDetail().getXpathLocation();
				}
				// If location is still null, then both of left and right
				// differences have been marked as null
				// This case should never happen
				if (xPathLocation == null) {
					LOG.warn("Null left and right differences found");
					xPathLocation = NULL_XPATH;
				}
				resultDiff.addDifference(new org.cerberus.serviceEngine.impl.diff.Difference(xPathLocation));
			}

			// Finally returns the String representation of our result structure
			return resultDiff.mkString();
		} catch (InputTranslatorException e) {
			LOG.warn("Unable to get differences from XML", e);
		}

		return null;
	}

	@Override
	public String removeDifference(String pattern, String differences) {
		if (pattern == null || differences == null) {
			LOG.warn("Null argument");
			return null;
		}

		try {
			// Gets the difference list from the differences
			Differences current = Differences.fromString(differences);
			Differences returned = new Differences();

			// Compiles the given pattern
			Pattern compiledPattern = Pattern.compile(pattern);
			for (org.cerberus.serviceEngine.impl.diff.Difference currentDiff : current.getDifferences()) {
				if (compiledPattern.matcher(currentDiff.getDiff()).matches()) {
					continue;
				}
				returned.addDifference(currentDiff);
			}

			// Returns the empty String if there is no difference left, or the
			// String XML representation
			return returned.mkString();
		} catch (DifferencesException e) {
			LOG.warn("Unable to remove differences", e);
		}

		return null;
	}

	@Override
	public boolean isElementEquals(TestCaseExecution tCExecution, String xpath, String expectedElement) {
		if (tCExecution == null || xpath == null || expectedElement == null) {
			LOG.warn("Null argument");
			return false;
		}

		try {
			NodeList candidates = XmlUtil.evaluate(executionSOAPResponse.getExecutionSOAPResponse(tCExecution.getExecutionUUID()), xpath);
			for (Document candidate : XmlUtil.fromNodeList(candidates)) {
				if (Differences.fromString(getDifferencesFromXml(XmlUtil.toString(candidate), expectedElement)).isEmpty()) {
					return true;
				}
			}
		} catch (XmlUtilException xue) {
			LOG.warn("Unable to check if element equality", xue);
		} catch (DifferencesException de) {
			LOG.warn("Unable to check if element equality", de);
		}

		return false;
	}
    @Override 
    public Document getXmlDocument(String uuid) {
        Document document = null;
        try {
            document =  XmlUtil.fromString(executionSOAPResponse.getExecutionSOAPResponse(uuid)) ; 
            return document;
        } catch (XmlUtilException ex) {
            java.util.logging.Logger.getLogger(XmlUnitService.class.getName()).log(Level.SEVERE, null, ex);
        }
        return document;
    }
}
