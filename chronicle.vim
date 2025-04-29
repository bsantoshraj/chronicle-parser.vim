" chronicle.vim - Vim Plugin for Google Chronicle SIEM Parser Assistance
"
" Provides commands to quickly insert parser skeletons, UDM blocks, and smart field mapping.

" Command to create a new parser skeleton
command! -nargs=1 ChronicleNewParser call chronicle#InsertYaraTemplate(<f-args>)

" Command to insert a static UDM mapping block
command! ChronicleNewUDM call chronicle#InsertUDMMapping()

" Command to dynamically create smart parse+map block
command! ChronicleSmartUDM call chronicle#SmartUDMMapping()

" Function to insert parser skeleton
function! chronicle#InsertYaraTemplate(parser_name)
    let l:template = [
          \ 'parser ' . a:parser_name,
          \ '{',
          \ '  meta:',
          \ '    author = "your.name@example.com"',
          \ '    description = "Describe your parser here"',
          \ '    log_type = "LOG_TYPE_HERE"',
          \ '',
          \ '  parse:',
          \ '    extract field_name1 regex "regex_pattern1"',
          \ '    extract field_name2 regex "regex_pattern2"',
          \ '',
          \ '  map:',
          \ '    set udm.event.primary_field to field_name1',
          \ '    set udm.event.secondary_field to field_name2',
          \ '}'
          \ ]

    call append(line('.'), l:template)
endfunction

" Function to insert static UDM mapping
function! chronicle#InsertUDMMapping()
    let l:udm_template = [
          \ 'map:',
          \ '  set udm.metadata.event_type to "EVENT_TYPE"',
          \ '  set udm.metadata.product_name to "PRODUCT_NAME"',
          \ '  set udm.network.src_ip to field_src_ip',
          \ '  set udm.network.dest_ip to field_dest_ip',
          \ '  set udm.network.src_port to field_src_port',
          \ '  set udm.network.dest_port to field_dest_port',
          \ '  set udm.principal.user.userid to field_userid',
          \ '  set udm.target.resource.name to field_target_resource',
          \ '  set udm.security_result.action to field_action',
          \ '  set udm.metadata.vendor_name to "VENDOR_NAME"'
          \ ]

    call append(line('.'), l:udm_template)
endfunction

" Function to dynamically create smart UDM mapping
function! chronicle#SmartUDMMapping()
    let l:field = input('Enter field name to extract: ')
    if empty(l:field)
        echo "Cancelled: No field name entered."
        return
    endif

    let l:regex = input('Enter regex pattern for ' . l:field . ': ')
    if empty(l:regex)
        echo "Cancelled: No regex entered."
        return
    endif

    let l:udm_field = input('Enter UDM field to map to (e.g., udm.network.src_ip): ')
    if empty(l:udm_field)
        echo "Cancelled: No UDM field entered."
        return
    endif

    let l:smart_block = [
          \ 'parse:',
          \ '  extract ' . l:field . ' regex "' . l:regex . '"',
          \ '',
          \ 'map:',
          \ '  set ' . l:udm_field . ' to ' . l:field
          \ ]

    call append(line('.'), l:smart_block)
endfunction

