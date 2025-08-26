# middle_tth_assignment
Middle Flutter Developer Take-To-Home assignment

[the assignment](https://docs.google.com/document/d/1YNYYau6YO1RCf_p_hGypc0YvEvrQ9R1dIoaz1SGJAtM/edit?tab=t.0)

## Architectural Overview

- **Data layer**:
  - _Http_: `dio`
    Interacts with the `rest.coincap.io/v3/`, gets assets page by page
- **Logic layer**: `bloc`
  `AssetsBloc` interacts with the API, fetches data and manages pagination
- **Presentation layer**
  Displays assets in a List, interacts with AssetsBloc
    
## Choice of technologies
- `dio`: requirement
- `bloc`: Enforces a certain type of architecture. Event-driven (separates presentation from logic).

## Some other code choices
A lot of design choices in this project were motivated by the fact that this is a small one-day application without any prospects of further development. This is the reason why I deliberately desided to not separate the Presentation layer into multiple files and to not include localization and interfaces.

