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
package org.cerberus.factory.impl;

import org.cerberus.entity.Test;
import org.cerberus.factory.IFactoryTest;
import org.springframework.stereotype.Service;

/**
 * @author bcivel
 */
@Service
public class FactoryTest implements IFactoryTest {

    @Override
    public Test create(String test, String description, String active, String automated, String tDateCrea) {
        Test newTest = new Test();
        newTest.setTest(test);
        newTest.setDescription(description);
        newTest.setActive(active);
        newTest.setAutomated(automated);
        newTest.settDateCrea(tDateCrea);

        return newTest;

    }
}
