

get_filename_component(ACADOS_INSTALL_DIR "${CMAKE_CURRENT_LIST_DIR}" DIRECTORY)

if(EXISTS ${ACADOS_INSTALL_DIR})
    message(STATUS "Found ACADOS.")
    set(ACADOS_FOUND TRUE)
else()
    message(FATAL_ERROR "Could not find ACADOS. ACADOS_SOURCE_DIR=${ACADOS_SOURCE_DIR} does not exist.")
endif()

set(ACADOS_LIBS acados hpipm blasfeo m)

set(
    ACADOS_INCLUDE_DIRECTORIES 
    ${ACADOS_INSTALL_DIR}/include 
    ${ACADOS_INSTALL_DIR}/include/acados
    ${ACADOS_INSTALL_DIR}/include/blasfeo/include
    ${ACADOS_INSTALL_DIR}/include/hpipm/include
)

set(ACADOS_LINK_DIRECTORIES ${ACADOS_DIR}/lib)

