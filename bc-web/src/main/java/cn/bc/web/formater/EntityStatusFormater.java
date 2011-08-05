/**
 * 
 */
package cn.bc.web.formater;

import java.util.HashMap;
import java.util.Map;

import cn.bc.core.RichEntity;

/**
 * Entity状态值的格式化
 * 
 * @author dragon
 * 
 */
public class EntityStatusFormater extends AbstractFormater {
	private Map<String, String> statuses;

	public EntityStatusFormater() {
		statuses = new HashMap<String, String>();
		statuses.put(String.valueOf(RichEntity.STATUS_DISABLED), "已禁用");
		statuses.put(String.valueOf(RichEntity.STATUS_ENABLED), "启用中");
		statuses.put(String.valueOf(RichEntity.STATUS_DELETED), "已删除");
	}

	public EntityStatusFormater(Map<String, String> statuses) {
		this.statuses = statuses;
	}

	public String format(Object context, Object value) {
		if (value == null)
			return null;

		String f = statuses.get(value.toString());
		return f == null ? "undefined" : f;
	}
}
