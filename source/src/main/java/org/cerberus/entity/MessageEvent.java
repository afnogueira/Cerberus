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
package org.cerberus.entity;

/**
 * {Insert class description here}
 *
 * @author Tiago Bernardes
 * @version 1.0, 19/Dez/2012
 * @since 0.9.0
 */
public class MessageEvent {

    /**
     * Message is used to feedback the result of any Cerberus event. Events
     * could by Property, Action, Control or even Step. For every event, we
     * have: - a number - a 2 digit code that report the status of the event. -
     * a clear message that will be reported to the user. describing what was
     * done or the error that occured. - a boolean that define whether the
     * complete test execution should stop or not. - a boolean that define
     * whether a screenshot will be done in case of problem (only if screenshot
     * option is set to 1). - the corresponding Execution message that will be
     * updated at the execution level.
     */
    private final int code;
    private final String codeString;
    private String description;
    private final boolean stopTest;
    private final boolean doScreenshot;
    private final boolean getPageSource;
    private final MessageGeneralEnum message;

    public MessageEvent(MessageEventEnum tempMessage) {
        this.code = tempMessage.getCode();
        this.codeString = tempMessage.getCodeString();
        this.description = tempMessage.getDescription();
        this.stopTest = tempMessage.isStopTest();
        this.doScreenshot = tempMessage.isDoScreenshot();
        this.message = tempMessage.getMessage();
        this.getPageSource = tempMessage.isGetPageSource();
    }

    public MessageEvent(MessageEventEnum tempMessage, boolean pageSource, boolean doScreenshot) {
        this.code = tempMessage.getCode();
        this.codeString = tempMessage.getCodeString();
        this.description = tempMessage.getDescription();
        this.stopTest = tempMessage.isStopTest();
        this.doScreenshot = doScreenshot;
        this.message = tempMessage.getMessage();
        this.getPageSource = pageSource;
    }

    public MessageGeneralEnum getMessage() {
        return message;
    }

    public boolean isStopTest() {
        return stopTest;
    }

    public boolean isDoScreenshot() {
        return doScreenshot;
    }
    
    public boolean isGetPageSource() {
        return getPageSource;
    }

    public int getCode() {
        return this.code;
    }

    public String getCodeString() {
        return codeString;
    }

    public String getDescription() {
        return this.description;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null || this.getClass() != obj.getClass()) {
            return false;
        }
        MessageEvent msg = (MessageEvent) obj;
        return this.code == msg.code;
    }

    @Override
    public int hashCode() {
        return super.hashCode();
    }

    /**
     * The only thing that can be changed is the description. All the rest is
     * static.
     *
     * @param description
     */
    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "MessageEvent{" + "code=" + code + ", codeString=" + codeString + ", description=" + description + ", stopTest=" + stopTest + ", doScreenshot=" + doScreenshot + ", getPageSource=" + getPageSource + ", message=" + message.toString() + '}';
    }
    
    
}
