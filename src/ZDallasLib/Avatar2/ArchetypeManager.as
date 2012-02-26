//Created by Action Script Viewer - http://www.buraks.com/asv
package ZDallasLib.Avatar2{
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;

    public class ArchetypeManager extends flash.events.EventDispatcher {

        private static var m_archetypes:flash.utils.Dictionary = new flash.utils.Dictionary();
        private static var m_xml:XML;

        public static function loadArchetypeFromURL(_arg1:String, _arg2:uint=15):Archetype{
            var _local3:Archetype = m_archetypes[_arg1];
            if (_local3 == null){
                _local3 = new Archetype(_arg1);
                _local3.loadFromURL(_arg1, _arg2);
                m_archetypes[_arg1] = _local3;
            };
            return (_local3);
        }

    }
}//package ZDallasLib.Avatar2
