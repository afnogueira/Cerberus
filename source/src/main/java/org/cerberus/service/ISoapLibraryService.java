/* DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
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
package org.cerberus.service;

import java.util.List;
import org.cerberus.entity.SoapLibrary;
import org.cerberus.exception.CerberusException;

/**
 *
 * @author cte
 */
public interface ISoapLibraryService {

    SoapLibrary findSoapLibraryByKey(String name) throws CerberusException;
    
    /**
     *
     * @param soapLibrary soapLibrary to insert
     * @throws CerberusException
     */
    void createSoapLibrary(SoapLibrary soapLibrary) throws CerberusException;

    /**
     *
     * @param soapLibrary soapLibrary to update using the key
     * @throws CerberusException
     */
    void updateSoapLibrary(SoapLibrary soapLibrary) throws CerberusException;

    /**
     *
     * @param soapLibrary soapLibrary to delete
     * @throws CerberusException
     */
    void deleteSoapLibrary(SoapLibrary soapLibrary) throws CerberusException;

    /**
     *
     * @return All SoapLibrary
     */
    List<SoapLibrary> findAllSoapLibrary();

    /**
     *
     * @param start first row of the resultSet
     * @param amount number of row of the resultSet
     * @param column order the resultSet by this column
     * @param dir Asc or desc, information for the order by command
     * @param searchTerm search term on all the column of the resultSet
     * @param individualSearch search term on a dedicated column of the
     * resultSet
     * @return
     */
    List<SoapLibrary> findSoapLibraryListByCriteria(int start, int amount, String column, String dir, String searchTerm, String individualSearch);
    
    /**
     * 
     * @param name Key of the table
     * @param columnName Name of the column
     * @param value New value of the columnName
     * @throws CerberusException 
     */
    void updateSoapLibrary(String name, String columnName, String value) throws CerberusException;
    
    /**
     * 
     * @param searchTerm words to be searched in every column (Exemple : article)
     * @param inds part of the script to add to where clause (Exemple : `type` = 'Article')
     * @return The number of records for these criterias
     */
    Integer getNumberOfSoapLibraryPerCrtiteria(String searchTerm, String inds);
    
}
