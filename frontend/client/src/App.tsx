import { Switch, Route, Router } from "wouter";
import { useHashLocation } from "wouter/use-hash-location";
import { queryClient } from "./lib/queryClient";
import { QueryClientProvider } from "@tanstack/react-query";
import { Toaster } from "@/components/ui/toaster";
import { TooltipProvider } from "@/components/ui/tooltip";
import { ThemeProvider } from "@/components/ThemeProvider";
import { AppShell } from "@/components/AppShell";
import ExplorerPage from "@/pages/explorer";
import PlatformDetailPage from "@/pages/platform-detail";
import StatsPage from "@/pages/stats";
import ComparePage from "@/pages/compare";
import NotFound from "@/pages/not-found";

function AppRouter() {
  return (
    <AppShell>
      <Switch>
        <Route path="/" component={ExplorerPage} />
        <Route path="/platform/:id" component={PlatformDetailPage} />
        <Route path="/stats" component={StatsPage} />
        <Route path="/compare" component={ComparePage} />
        <Route component={NotFound} />
      </Switch>
    </AppShell>
  );
}

function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <ThemeProvider>
        <TooltipProvider>
          <Toaster />
          <Router hook={useHashLocation}>
            <AppRouter />
          </Router>
        </TooltipProvider>
      </ThemeProvider>
    </QueryClientProvider>
  );
}

export default App;
