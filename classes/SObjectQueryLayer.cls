public abstract class SObjectQueryLayer {

    @TestVisible
    protected String getFieldListString(String fieldSetName) {
        List<String> fields = new List<String>();
        Schema.DescribeSObjectResult descrSObj = getSObjectType().getDescribe();
        try {
            for(Schema.FieldSetMember member : descrSObj.fieldSets.getMap().get(fieldSetName).getFields()) {
                fields.add(member.getFieldPath());
            }
        } catch(Exception ex) {
            throw new SelectorException('Fieldset ' + fieldSetName + ' not found.');
        }

        return String.join(fields, ',');
    }

    protected abstract Schema.SObjectType getSObjectType();

    @TestVisible
    protected String getSObjectName() {
        return getSObjectType().getDescribe().getName();
    }

    protected virtual String getOrderBy() {
        return 'Name';
    }

    @TestVisible
    protected String getQuery(String fieldSetName, String conditions) {
        String[] parts = new String[]{getFieldListString(fieldSetName), getSObjectName(), conditions};
        String query = String.format('SELECT {0} FROM {1} WHERE {2}', parts);

        return query;
    }

    public String getQueryBySet(String nameSet, String conditions) {
        String[] parts = new String[]{nameSet, getSObjectName(), conditions};
        String query = String.format('SELECT {0} FROM {1} WHERE {2}', parts);

        return query;
    }

    public List<sObject> selectById(String idField, Set<ID> idSet, String fieldSetName) {
        assertIsAccessible();
        String[] parts = new String[]{getFieldListString(fieldSetName), getSObjectName(), getOrderBy()};
        String query = String.format('SELECT {0} FROM {1} WHERE ' + idField  + ' IN :idSet ORDER BY {2}', parts);

        return Database.query(query);
    }

    public List<sObject> selectById(String idField, ID id, String fieldSetName) {
        assertIsAccessible();
        String[] parts = new String[]{getFieldListString(fieldSetName), getSObjectName(), getOrderBy()};
        String query = String.format('SELECT {0} FROM {1} WHERE ' + idField  + ' = :id ORDER BY {2}', parts);

        return Database.query(query);
    }

    public List<sObject> selectByFieldVal(String field, String val, String fieldSetName) {
        assertIsAccessible();
        String[] parts = new String[]{getFieldListString(fieldSetName), getSObjectName(), getOrderBy()};
        String query = String.format('SELECT {0} FROM {1} WHERE ' + field + ' = :val ORDER BY {2}', parts);

        return Database.query(query);
    }

    protected void assertIsAccessible() {
        if(!getSObjectType().getDescribe().isAccessible()) {
            throw new SelectorException('Permission to access an ' + getSObjectType().getDescribe().getName() + ' denied.');
        }
    }

    public class SelectorException extends Exception {}

}