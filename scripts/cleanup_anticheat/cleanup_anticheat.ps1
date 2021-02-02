get-ciminstance win32_service -filter "name='EasyAntiCheat'" | remove-ciminstance
get-ciminstance win32_service -filter "name='beservice'" | remove-ciminstance