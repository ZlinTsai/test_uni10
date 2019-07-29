CXX           := icpc
CXXFLAGS      := -m64 -O3 -Wall -qopenmp -pthread -std=c++11
UNI10CXXFLAGS := -DUNI_CPU -DUNI_LAPACK -DUNI_MKL
UNI10_ROOT    := /home/zlintsai/src/uni10
ROOTS         := /home/zlintsai/src/uni10
UNI10_VERSION :=
MAINSCRIPT    := $(code)
SRCDIRS       := 
SRC           := 

# Check variable
ifeq ($(wildcard $(code)),)
	$(error Enter code=XXX.cpp)
endif

ifeq ($(wildcard $(name)),)
	name := job.exe
endif

# The name of binary object.
EXU := $(MAINSCRIPT)

# Search the source files in under paths.
vpath %.cpp  $(SRCDIRS)

# The file names of source codes.
src := $(SRC)

COMMON_FLAGS_INCS += $(foreach root,$(ROOTS),-I$(root)/include)
COMMON_FLAGS_LIBS += $(foreach root,$(ROOTS),-L$(root)/lib)
CXXFLAGS += $(UNI10CXXFLAGS)
UNI10LDLIBRARY :=
ifeq ($(UNI10_VERSION), )
    UNI10LDLIBRARY = -luni10
else
    UNI10LDLIBRARY = $(addprefix -luni10_, $(UNI10_VERSION))
endif

OBJ_DIR := objects
OBJECTS := $(patsubst %.cpp, $(OBJ_DIR)/%.o, $(src))

all: job.exe

job.exe: $(EXU) | $(OBJECTS)
	$(CXX) $(COMMON_FLAGS_INCS) $(COMMON_FLAGS_LIBS) $(CXXFLAGS) $^ -o $(name) $(OBJECTS) $(UNI10LDLIBRARY) 

$(OBJECTS): | $(OBJ_DIR)

$(OBJ_DIR):
	@mkdir -p $@

$(OBJ_DIR)/%.o: %.cpp
	$(CXX) $(COMMON_FLAGS_INCS) $(CXXFLAGS) -c $< -o $@

Clean:
	rm -rf *.exe $(OBJ_DIR)

clean:
	touch job.exe
	rm job.exe
