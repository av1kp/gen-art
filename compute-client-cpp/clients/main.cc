// Client side C/C++ program to demonstrate Socket
// programming

#include <iostream>

#include "absl/flags/flag.h"
#include "absl/flags/parse.h"
#include "absl/log/log.h"
#include "absl/strings/str_cat.h"
#include "io/feedback_http_server.h"
#include "io/json_handler.h"
#include "io/sketch_client_socket.h"

#include "clients/interlocked/art_generator.h"

ABSL_FLAG(std::string, project_name, "",
    "Name of the art project.");
ABSL_FLAG(bool, start_http_server, false,
    "Start the local HTTP server.");

const char kWelcomeAsciiArt[] = R"(

$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'               `$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$  
$$$$$$$$$$$$$$$$$$$$$$$$$$$$'                   `$$$$$$$$$$$$$$$$$$$$$$$$$$$$
$$$'`$$$$$$$$$$$$$'`$$$$$$!                       !$$$$$$'`$$$$$$$$$$$$$'`$$$
$$$$  $$$$$$$$$$$  $$$$$$$                         $$$$$$$  $$$$$$$$$$$  $$$$
$$$$. `$' \' \$`  $$$$$$$!                         !$$$$$$$  '$/ `/ `$' .$$$$
$$$$$. !\  i  i .$$$$$$$$                           $$$$$$$$. i  i  /! .$$$$$
$$$$$$   `--`--.$$$$$$$$$                           $$$$$$$$$.--'--'   $$$$$$
$$$$$$L        `$$$$$^^$$                           $$^^$$$$$'        J$$$$$$
$$$$$$$.   .'   ""~   $$$    $.                 .$  $$$   ~""   `.   .$$$$$$$
$$$$$$$$.  ;      .e$$$$$!    $$.             .$$  !$$$$$e,      ;  .$$$$$$$$
$$$$$$$$$   `.$$$$$$$$$$$$     $$$.         .$$$   $$$$$$$$$$$$.'   $$$$$$$$$
$$$$$$$$    .$$$$$$$$$$$$$!     $$`$$$$$$$$'$$    !$$$$$$$$$$$$$.    $$$$$$$$
$$$$$$$     $$$$$$$$$$$$$$$$.    $    $$    $   .$$$$$$$$$$$$$$$$     $$$$$$$
                                 $    $$    $
                                 $.   $$   .$
                                 `$        $'
                                  `$$$$$$$$'

)";

/*
std::string MakeMessage() {
  using genart::ArtPiece;
  ArtPiece art;
  art.FillDummyValues();
  return art.ToJsonString();
}*/

int main(int argc, char* argv[]) {
  absl::ParseCommandLine(argc, argv);

  std::cout << kWelcomeAsciiArt;
  const std::string project = absl::GetFlag(FLAGS_project_name);
  LOG(INFO) << "\t Started gen-art backend .. "
      << absl::StrCat("{", project, "}") << "\n";
  
  if (project == "interlocked") {
    genart::interlocked::RunArtGeneration();
  } else {
    LOG(FATAL) << "Invalid project: " << project;
  }

  /*
  genart::SketchClientSocket client;
  const std::string message = MakeMessage();
  LOG(INFO) << "Sending message: [" << message << "]";
  client.SendData(message);
  */


  if (absl::GetFlag(FLAGS_start_http_server)) {
    genart::FeedbackHttpServer server;
    server.Start();
    server.Wait();
  }
  genart::TestJson();
}