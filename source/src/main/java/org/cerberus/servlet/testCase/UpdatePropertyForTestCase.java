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
package org.cerberus.servlet.testCase;

import java.io.IOException;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.cerberus.exception.CerberusException;
import org.cerberus.service.ITestCaseCountryPropertiesService;
import org.owasp.html.PolicyFactory;
import org.owasp.html.Sanitizers;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

/**
 * {Insert class description here}
 *
 * @author Frederic LESUR
 * @version 1.0, 24/03/2014
 * @since 0.9.0
 */
@WebServlet(name="UpdatePropertyForTestCase" ,value = "/UpdatePropertyForTestCase")
public class UpdatePropertyForTestCase extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse) throws ServletException, IOException {
        PolicyFactory policy = Sanitizers.FORMATTING.and(Sanitizers.LINKS);
        String name = policy.sanitize(httpServletRequest.getParameter("name"));
        String property = policy.sanitize(httpServletRequest.getParameter("pk[property]"));
        String testName = policy.sanitize(httpServletRequest.getParameter("pk[test]"));
        String testCaseName = policy.sanitize(httpServletRequest.getParameter("pk[testcase]"));
        String value = policy.sanitize(httpServletRequest.getParameter("value"));
        
        ApplicationContext appContext = WebApplicationContextUtils.getWebApplicationContext(this.getServletContext());
        
        try {

            ITestCaseCountryPropertiesService testCaseCountryPropertiesService = appContext.getBean(ITestCaseCountryPropertiesService.class);
            
            testCaseCountryPropertiesService.updateTestCasePropertiesColumn(testName, testCaseName, property, name, value);
        } catch (CerberusException ex) {
            Logger.getLogger(UpdatePropertyForTestCase.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
    }
}
