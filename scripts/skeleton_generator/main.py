from importlib import import_module
import os
#import timing

format = 'print'
max_depth = 3

content_modules = {}

def generate_nesting(type, depth=1, selector_context='', slot_context=''):
    # Don't nest root types.
    has_parent = getattr(content_modules[type], 'has_parent', True)
    if depth > 1 and not has_parent:
        return
    if depth == 1 and has_parent:
        return

    # Prepare contexts.
    current_selector_context = ' '.join([x for x in (selector_context, content_modules[type].selector) if x])
    next_slot_context = '; '.join([x for x in (slot_context, content_modules[type].slot_context) if x])

    # Include the slot context for this type if it is a "kind" of content.
    # eg, an "ordered" list, or a "how to" feature.
    if ", '" in content_modules[type].slot_context:
        slot_context = next_slot_context

    # Output the current nesting.
    print """
%(selector)s {
  %(mixin)s(%(context)s);
}""" % {'selector': current_selector_context,
        'mixin': content_modules[type].slot_name,
        'context': slot_context}

    # Stop at a max depth.
    if depth >= max_depth:
        return

    # Stop if the current content type does not nest content inside it.
    has_children = getattr(content_modules[type], 'has_children', True)
    if not has_children:
        return

    # Generate further nestings for each content type.
    for content_type in content_modules:
        generate_nesting(content_type,
                         depth+1,
                         selector_context=current_selector_context,
                         slot_context=next_slot_context
        )

if __name__ == '__main__':
    try:
        import argparse
    except ImportError:
        print "Argparse is required, and missing. Try easy_install argparse, pip install argparse, etc."
        sys.exit(2)

    parser = argparse.ArgumentParser(description='Generate content nesting Skeletons')
    parser.add_argument("-f", "--format", dest="format", help="Target output format. (print, web, epub, etc)")
    parser.add_argument("-d", "--depth", dest="max_depth", type=int, help="Maximum nesting depth.")
    parser.set_defaults(format="print", max_depth=3)
    args = parser.parse_args()

    format = args.format
    max_depth = args.max_depth

    # Load all content types from modules in the content/ directory.
    for type in [x for x in os.listdir('content/%s' % format) if os.path.isdir('content/%s/%s' % (format, x))]:
        if not type in content_modules:
            content_modules[type] = import_module('content.%s.%s' % (format, type))

    # Generate nestings for each content type.
    for content_type in content_modules:
        generate_nesting(content_type)

# mixin_token, selector_token, context_token
